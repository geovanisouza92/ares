
BINARY = "arc"

MODULES = [
  "st",
  "stoql",
  "stmt",
  "parser",
  "scanner",
  "driver",
  "codegen",
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
  "sigla"
]

desc "Gerar protótipo versão debug"
task :default do
  # Flags de compilação do C++
  CXXFLAGS = [ 
    "-g3",
    "-emit-llvm",
    "-Wall",
    "-c",
    "-fmessage-length=0",
    "-Wno-unused-function",
    "-Wno-logical-op-parentheses",
    "-Wno-switch-enum",
    "-DLANG_DEBUG=1"
    # , "`llvm-config --cxxflags engine`"
  ]

  # Flags de ligação
  LDFLAGS = [
    "-v",
    "-native"
    # , "`llvm-config --ldflags --libs engine`"
  ]

  # Flags do Yacc
  YFLAGS = [
    "--debug",
    "-v",
    "-x",
    "--defines=parser.hpp"
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
    "-x",
    "--defines=parser.hpp"
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
  # unless YFLAGS
    YFLAGS = [
      "--debug",
      "-v",
      "-x",
      "--defines=parser.hpp"
    ]
  # end
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
  Rake::Task['docs'].invoke unless File.exists?(File.join(Dir.getwd, 'tcc', 'grammar.tex'))
  Dir.chdir(TCC)
  Rake::Task['bb'].invoke
  Rake::Task['tex'].invoke
  Rake::Task['indexes'].invoke
  Rake::Task['bibtex'].invoke
  Rake::Task['tex'].invoke
  Rake::Task['tex'].invoke
  Dir.chdir('..')
end

# Gera meta-info das imagens
task :bb do
  sh "ebb #{File.join(File.dirname(__FILE__), TCC, 'figuras', '*.*')}"
end

# Compila o PdfLaTeX
task :tex do
  sh "pdflatex -interaction=nonstopmode -output-directory=#{File.join(File.dirname(__FILE__), TCC)} -output-format=pdf #{File.join(File.dirname(__FILE__), TCC, TCC.ext('tex'))}"
end

# Gera os índices
task :indexes do
  TCCINDEX.each do |index|
    sh "makeindex -s tabela-simbolos.ist -o #{File.join(File.dirname(__FILE__), TCC, TCC.ext(index))} #{File.join(File.dirname(__FILE__), TCC, TCC.ext(index + "x"))}"
  end
end

# Gera as referências bibliográficas
task :bibtex do
  sh "bibtex #{File.join(File.dirname(__FILE__), TCC, TCC)}"
end

desc "Gera a documentação da gramática"
task :docs => [ 'parser.cpp' ] do
  Y2LFLAGS = [
    "-p",
    File.join(Dir.getwd, 'parser.yacc')
  ]
  sh "xsltproc #{File.join(Dir.getwd, 'docs', 'xslt', 'xml2xhtml.xsl')} #{File.join(Dir.getwd, 'parser.xml')} > #{File.join(Dir.getwd, 'docs', 'Grammar.html')}" unless File.exists?(File.join(Dir.getwd, 'docs', 'Grammar.html'))
  # sh "y2l #{Y2LFLAGS.join(" ")}" unless File.exists?(File.join(Dir.getwd, 'tcc', 'grammar.tex'))
end

require 'rake/clean'

CLEAN.include(BINARY)
CLEAN.include("parser.cpp")
CLEAN.include("parser.hpp")
CLEAN.include("parser.xml")
CLEAN.include("scanner.cpp")
CLEAN.include("*.hh")
CLEAN.include("*.out*")
CLEAN.include("*.results")
CLEAN.include("*.diff")
CLEAN.include("*.s")
CLEAN.include("*.bc")
CLEAN.include(File.join("docs", "Grammar.html"))

CLEAN.include(File.join(TCC, "*.aux"))
CLEAN.include(File.join(TCC, "*.log"))
CLEAN.include(File.join(TCC, "*.toc"))
CLEAN.include(File.join(TCC, "*.bbl"))
CLEAN.include(File.join(TCC, "*.blg"))
CLEAN.include(File.join(TCC, "*.out*"))
CLEAN.include(File.join(TCC, "#{TCC}.pdf"))
CLEAN.include(File.join(TCC, "figuras", "*.bb"))
CLEAN.include(File.join(TCC, "*.ilg"))
CLEAN.include(File.join(TCC, "*.sym*"))
CLEAN.include(File.join(TCC, "*.sig*"))
CLEAN.include(File.join(TCC, "*.rom*"))
CLEAN.include(File.join(TCC, "*.gre*"))
CLEAN.include(File.join(TCC, "*.mis*"))
CLEAN.include(File.join(TCC, "grammar.tex"))
