
BINARY = "arc"

MODULES = [
  "st",
  "stoql",
  "stmt",
  "parser",
  "scanner",
  "driver",
  "main"
]

# Diretório de bibliotecas para Linux
LIBDIRS = [
  File.join(
    "/",
    "usr",
    "lib",
    "gcc",
    "i686-linux-gnu",
    "4.6/"
  ),
  File.join(
    "/",
    "home",
    "geovani",
    "dev",
    "boost_1_48_0",
    "bin.v2",
    "libs",
    "program_options",
    "build",
    "gcc-4.6.1",
    "release",
    "link-static",
    "threading-multi"
  ),
  File.join(
    "/",
    "home",
    "geovani",
    "dev",
    "boost_1_48_0",
    "bin.v2",
    "libs",
    "system",
    "build",
    "gcc-4.6.1",
    "release",
    "link-static",
    "threading-multi"
  ),
  File.join(
    "/",
    "home",
    "geovani",
    "dev",
    "boost_1_48_0",
    "bin.v2",
    "libs",
    "filesystem",
    "build",
    "gcc-4.6.1",
    "release",
    "link-static",
    "threading-multi"
  )
]

# Bibliotecas utilizadas (dependências)
LIBS = [
  "stdc++",
  "boost_filesystem",
  "boost_program_options",
  "boost_system"
]

# Flags de execução do programa (apenas para teste)
BINFLAGS = [
  "--verbose=1"
]

TCC = "tcc"

TCCINDEX = [
  "siglas"
]

desc "Gerar protótipo versão debug"
task :default do
  # Flags de compilação do C++
  CXXFLAGS = [ 
    "-O0", 
    "-g3",
    "-emit-llvm",
    "-Wall",
    "-c",
    "-fmessage-length=0",
    "-Wno-unused-function",
    "-Wno-logical-op-parentheses",
    "-Wno-switch-enum",
    "-DLANG_DEBUG=1"
  ]

  # Flags de ligação
  LDFLAGS = [
    "-v",
    "-native"
  ]

  # Flags do Yacc
  YFLAGS = [
    "--debug",
    "-v",
    "--defines=parser.h"
  ]

  # Flags do Lex
  LFLAGS = [
    "--debug"
  ]

  Rake::Task['link'].invoke
end

desc "Gerar protótipo versão release"
task :release => :clean do
  # Flags de compilação do C++
  CXXFLAGS = [
    "-O3",
    "-emit-llvm",
    "-Wall",
    "-c",
    "-fmessage-length=0",
    "-Wno-unused-function",
    "-Wno-logical-op-parentheses",
    "-Wno-switch-enum"
  ]

  # Flags de ligação
  LDFLAGS = [
    "-v"
  ]

  # Flags do Yacc
  YFLAGS = [
    "-v",
    "--defines=parser.h"
  ]

  # Flags do Lex
  LFLAGS = [
    ""
  ]

  Rake::Task['link'].invoke

  sh "llc -x86-asm-syntax=att -o #{BINARY}.s #{BINARY}.bc"

  cmd = "gcc -fno-strict-aliasing -O3 -o #{BINARY} #{BINARY}.s "
  LIBDIRS.each do |libdir|
    cmd << "-L#{libdir} "
  end
  LIBS.each do |lib|
    cmd << "-l#{lib} "
  end
  sh cmd

end

file 'parser.cpp' do |f|
  sh "bison #{YFLAGS.join(' ')} -o #{f.name} parser.yacc"
end

file 'scanner.cpp' do |f|
  sh "flex #{LFLAGS.join(' ')} -o#{f.name} scanner.lex"
end

rule '.bc' => '.cpp' do |f|
  sh "clang++ #{CXXFLAGS.join(' ')} -o #{f.name} #{f.source}"
end

bc = []
MODULES.each { |mod| bc << "#{mod}.bc" }

task :link => bc do
  cmd = "llvm-ld #{LDFLAGS.join(' ')} -o #{BINARY} "
  MODULES.each do |mod|
    cmd << "#{mod}.bc "
  end
  LIBDIRS.each do |libdir|
    cmd << "-L#{libdir} "
  end
  LIBS.each do |lib|
    cmd << "-l#{lib} "
  end
  sh cmd
end

desc "Realiza os testes de compilação básicos"
task :test do
  if File.exists?(BINARY)
    test_files = Dir.glob("tests/*.ar")
    cmd = "#{File.join(File.dirname(__FILE__), BINARY)} "
    cmd << "#{BINFLAGS.join(' ')} "
    cmd << "#{test_files.flatten.join(' ')}"
    sh cmd
  else
    puts "Compile o protótipo antes de testar"
  end
end

desc "Gerar TCC"
task :tcc do
  Dir.chdir(TCC)
  Rake::Task['bb'].invoke
  Rake::Task['tex'].invoke
  Rake::Task['indexes'].invoke
  Rake::Task['bibtex'].invoke
  Rake::Task['tex'].invoke
  Rake::Task['tex'].invoke
  Dir.chdir("..")
end

# Gera meta-info das imagens
task :bb do
  sh "ebb #{File.join(File.dirname(__FILE__), TCC, 'figuras', '*.*')}"
end

# Compila o PdfLaTeX
task :tex do
  sh "pdflatex -interaction=nonstopmode -output-directory=#{File.join(File.dirname(__FILE__), TCC)} -output-format=pdf #{File.join(File.dirname(__FILE__), TCC, TCC)}"
end

# Gera os índices
task :indexes do
  TCCINDEX.each do |index|
    sh "makeindex -s tabela-simbolos.ist -o #{File.join(File.dirname(__FILE__, TCC))}#{TCC.ext(index)} #{File.join(File.dirname(__FILE__), TCC)}#{TCC.ext(index + "x")}"
  end
end

# Gera as referências bibliográficas
task :bibtex do
  sh "bibtex #{File.join(File.dirname(__FILE__, TCC))}#{TCC}"
end

require 'rake/clean'

CLEAN.include(BINARY)
CLEAN.include("parser.cpp")
CLEAN.include("parser.h")
CLEAN.include("scanner.cpp")
CLEAN.include("*.hh")
CLEAN.include("*.out*")
CLEAN.include("*.results")
CLEAN.include("*.diff")
CLEAN.include("*.s")
CLEAN.include("*.bc")
CLEAN.include("*.aux")
CLEAN.include("*.toc")
CLEAN.include("*.log")
CLEAN.include("*.bbl")
CLEAN.include("*.blg")
CLEAN.include("*.out*")
CLEAN.include("#{TCC}.pdf")
CLEAN.include("*.bb")
CLEAN.include("*.ilg")
CLEAN.include("*.sym*")
CLEAN.include("*.sig*")
CLEAN.include("*.rom*")
CLEAN.include("*.gre*")
CLEAN.include("*.mis*")
