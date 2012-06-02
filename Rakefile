
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
  Dir.chdir('src')

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
    "--defines=#{File.join(File.dirname(__FILE__), 'src', 'parser.hpp')}",
    "-o #{File.join(File.dirname(__FILE__), 'src', 'parser.cpp')}"
  ]

  # Flags do Lex
  LFLAGS = [
    "--debug",
    "-o#{File.join(File.dirname(__FILE__), 'src', 'scanner.cpp')}"
  ]

  Rake::Task['link'].invoke

  Dir.chdir('..')
end

desc "Gerar protótipo versão release"
task :release => :clean do
  Dir.chdir('src')

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
    "--defines=#{File.join(File.dirname(__FILE__), 'src', 'parser.hpp')}",
    "-o #{File.join(File.dirname(__FILE__), 'src', 'parser.cpp')}"
  ]

  # Flags do Lex
  LFLAGS = [
    "-o#{File.join(File.dirname(__FILE__), 'src', 'scanner.cpp')}"
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

  Dir.chdir('..')

end

file 'parser.cpp' do |f|
  puts "Gerando parser"
  unless File.exists?(File.join(File.dirname(__FILE__), 'src', 'parser.xml')) and (!YFLAGS)
    YFLAGS = [
      "--debug",
      "-v",
      "-x",
      "--defines=#{File.join(File.dirname(__FILE__), 'src', 'parser.hpp')}",
      "-o #{File.join(File.dirname(__FILE__), 'src', 'parser.cpp')}"
    ]
    # Dir.chdir('src')
    # Rake::Task['parser.cpp'].invoke
    # Dir.chdir('..')
  end
  sh "bison #{YFLAGS.join(' ')} #{File.join(File.dirname(__FILE__), 'src', 'parser.yacc')}" unless File.exists?(File.join(File.dirname(__FILE__), 'src', 'parser.cpp'))
end

file 'scanner.cpp' do |f|
  puts "Gerando scanner"
  sh "flex #{LFLAGS.join(' ')} #{File.join(File.dirname(__FILE__), 'src', 'scanner.lex')}"
end

rule '.bc' => '.cpp' do |f|
  puts "Gerando módulo #{f.name}"
  sh "clang++ #{CXXFLAGS.join(' ')} -o #{File.join(File.dirname(__FILE__), 'src', f.name)} #{File.join(File.dirname(__FILE__), 'src', f.source)}"
end

bc = []
MODULES.each { |mod| bc << "#{mod.ext('bc')}" }

task :link => bc do
  puts "Linkando binário"
  cmd = "llvm-ld #{LDFLAGS.join(' ')} -o #{File.join(File.dirname(__FILE__), 'bin', BINARY)} "
  MODULES.each do |mod|
    cmd << "#{File.join(File.dirname(__FILE__), 'src', mod.ext('bc'))} "
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
  puts "Iniciando testes"
  if File.exists?(File.join(File.dirname(__FILE__), 'bin', BINARY))
    test_files = Dir.glob("tests/*.ar")
    cmd = "#{File.join(File.dirname(__FILE__), 'bin', BINARY)} "
    cmd << "#{BINFLAGS.join(' ')} "
    cmd << "#{test_files.flatten.join(' ')}"
    sh cmd
    puts "Testes concluídos"
  else
    puts "Compile o protótipo antes de testar"
  end
end

desc "Gerar TCC"
task :tcc do
  puts "Gerando TCC"
  Rake::Task['docs'].invoke unless File.exists?(File.join(File.dirname(__FILE__), TCC, 'grammar.tex'))
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
    sh "makeindex -s tabela-simbolos.ist -o #{File.join(File.dirname(__FILE__), TCC, TCC.ext(index))} #{File.join(File.dirname(__FILE__), TCC, TCC.ext(index + 'x'))}"
  end
end

# Gera as referências bibliográficas
task :bibtex do
  sh "bibtex #{File.join(File.dirname(__FILE__), TCC, TCC)}"
end

desc "Gera a documentação da gramática"
task :docs => [ :clean, 'parser.cpp' ] do
  puts "Gerando documentação"
  resumir_relatorio unless ENV['completo']
  gerar_relatorios
  gerar_tex
end

def resumir_relatorio
  puts "Resumindo relatório do parser"
  org = File.new File.join(File.dirname(__FILE__), 'src', 'parser.xml'), 'r'
  dest = File.new File.join(File.dirname(__FILE__), 'docs', 'grammar.xml'), 'w'
  dest.write "<?xml version=\"1.0\"?>\n<bison-xml-report version=\"2.5\" bug-report=\"bug-bison@gnu.org\" url=\"http://www.gnu.org/software/bison/\">\n<filename>Ares</filename><grammar>"
  while line = org.gets
    if line =~ /^.*<rules>.*$/
      dest.write line
      dest.write line while line = org.gets and line !~ /^.*<\/rules>.*$/
      dest.write line
    end
  end
  dest.write "</grammar></bison-xml-report>\n"
  dest.close
  org.close
end

def gerar_relatorios
  puts "Gerando relatórios HTML e TXT do parser"

  xslflags = [ File.join(File.dirname(__FILE__), 'docs', 'xslt', 'xml2xhtml.xsl') ]
  unless ENV['completo']
    xslflags << [ File.join(File.dirname(__FILE__), 'docs', 'grammar.xml') ]
  else
    xslflags << [ File.join(File.dirname(__FILE__), 'src', 'parser.xml') ]
  end
  xslflags << [ "> #{File.join(File.dirname(__FILE__), 'docs', 'grammar.html')}" ]
  sh "xsltproc #{xslflags.join(" ")} "

  xslflags = [ File.join(File.dirname(__FILE__), 'docs', 'xslt', 'xml2text.xsl') ]
  unless ENV['completo']
    xslflags << [ File.join(File.dirname(__FILE__), 'docs', 'grammar.xml') ]
  else
    xslflags << [ File.join(File.dirname(__FILE__), 'src', 'parser.xml') ]
  end
  xslflags << [ "> #{File.join(File.dirname(__FILE__), 'docs', 'grammar.bnf')}" ]
  sh "xsltproc #{xslflags.join(" ")} "
end

def gerar_tex
  dest = File.new File.join(File.dirname(__FILE__), TCC, 'grammar.tex'), 'w'
  dest.write "\\apendice\\chapter{Gram\\'atica BNF da linguagem de programa\\ca o do prot\\'otipo}\\begin{espacosimples}\\begin{scriptsize}\\begin{lstlisting}"
  org = File.new File.join(File.dirname(__FILE__), 'docs', 'grammar.bnf'), 'r'
  while line = org.gets
    line = line.gsub(/\$/, '\\$') if line =~ /\$/
    dest.write line unless line =~ /Grammar/
  end
  dest.write "\\end{lstlisting}\\end{scriptsize}\\end{espacosimples}"
  dest.close
  org.close
end

require 'rake/clean'

CLEAN.include(File.join('bin', BINARY))
CLEAN.include(File.join('bin', BINARY.ext('bc')))
CLEAN.include(File.join('src', 'parser.cpp'))
CLEAN.include(File.join('src', 'parser.hpp'))
CLEAN.include(File.join('src', 'parser.xml'))
CLEAN.include(File.join('src', 'scanner.cpp'))
CLEAN.include(File.join('src', '*.hh'))
CLEAN.include(File.join('src', '*.out*'))
CLEAN.include(File.join('src', '*.results'))
CLEAN.include(File.join('src', '*.diff'))
CLEAN.include(File.join('src', '*.s'))
CLEAN.include(File.join('src', '*.bc'))
CLEAN.include(File.join('docs', 'grammar.html'))
CLEAN.include(File.join('docs', 'grammar.txt'))
CLEAN.include(File.join(TCC, 'grammar.tex'))
CLEAN.include(File.join('docs', 'grammar.bnf'))
CLEAN.include(File.join('docs', 'grammar.xml'))
CLEAN.include(File.join('docs', '*.aux'))
CLEAN.include(File.join('docs', '*.log'))
CLEAN.include(File.join('docs', '*.out'))
CLEAN.include(File.join('docs', '*.pdf'))
CLEAN.include(File.join('docs', '*.syn*'))
CLEAN.include(File.join(TCC, '*.aux'))
CLEAN.include(File.join(TCC, '*.log'))
CLEAN.include(File.join(TCC, '*.toc'))
CLEAN.include(File.join(TCC, '*.bbl'))
CLEAN.include(File.join(TCC, '*.blg'))
CLEAN.include(File.join(TCC, '*.out*'))
CLEAN.include(File.join(TCC, "#{TCC}.pdf"))
CLEAN.include(File.join(TCC, 'figuras', '*.bb'))
CLEAN.include(File.join(TCC, '*.ilg'))
CLEAN.include(File.join(TCC, '*.sym*'))
CLEAN.include(File.join(TCC, '*.sig*'))
CLEAN.include(File.join(TCC, '*.rom*'))
CLEAN.include(File.join(TCC, '*.gre*'))
CLEAN.include(File.join(TCC, '*.mis*'))
