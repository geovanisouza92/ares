
BINARY=:arc
MODULES=[ :st, :stoql, :stmt, :parser, :scanner, :driver, :main ]
files_to_clean=[ "parser.cpp", "parser.h", "scanner.cpp" ]
files_to_clean.push(Dir.glob("*.hh"))
files_to_clean.push(Dir.glob("*.out*"))
files_to_clean.push(Dir.glob("*.results"))
files_to_clean.push(Dir.glob("*.diff"))
files_to_clean.push("#{BINARY}") if File.exists?("#{BINARY}")
files_to_clean.push("#{BINARY}.s") if File.exists?("#{BINARY}.s")
files_to_clean.push("#{BINARY}.bc") if File.exists?("#{BINARY}.bc")

LIBDIRS=[
  "/usr/lib/gcc/i686-linux-gnu/4.6/",
  "/home/geovani/dev/boost_1_48_0/bin.v2/libs/program_options/build/gcc-4.6.1/release/link-static/threading-multi",
  "/home/geovani/dev/boost_1_48_0/bin.v2/libs/system/build/gcc-4.6.1/release/link-static/threading-multi",
  "/home/geovani/dev/boost_1_48_0/bin.v2/libs/filesystem/build/gcc-4.6.1/release/link-static/threading-multi"
]
LIBS=[
  "stdc++",
  "boost_filesystem",
  "boost_program_options",
  "boost_system"
]

if ENV["debug"]
CXXFLAGS="-O0 -g3 -emit-llvm -Wall -c -fmessage-length=0 -Wno-unused-function -Wno-logical-op-parentheses -Wno-switch-enum -DLANG_DEBUG=1"
LDFLAGS="-v -native"
YFLAGS="--debug -v --defines=parser.h"
LFLAGS="--debug"
elsif ENV["release"]
CXXFLAGS="-O3 -emit-llvm -Wall -c -fmessage-length=0 -Wno-unused-function -Wno-logical-op-parentheses -Wno-switch-enum"
LDFLAGS="-v"
YFLAGS="-v --defines=parser.h"
LFLAGS=""
end

task :default => [ :clear, :bitcode, :link, :assembly, :native ]

task :clear do
  # Delete previous bitcode modules
  MODULES.each do |mod|
    File.delete("#{mod}.bc") if File.exists?("#{mod}.bc")
  end
  files_to_clean.flatten.each do |file|
    # puts "Delete file #{file}"
    File.delete(file) if File.exists?(file)
  end
end

task :bitcode do
  # Check for each bitcode module
  MODULES.each do |mod|
    unless File.exists? "#{mod}.cpp"
      case mod
        when :parser
          cmd = "bison #{YFLAGS} -o #{mod}.cpp #{mod}.yacc"
          puts cmd
          system cmd
        when :scanner
          cmd = "flex #{LFLAGS} -o#{mod}.cpp #{mod}.lex"
          puts cmd
          system cmd
        end
      end
    # Generate bitcode for each file.cpp
    cmd = "clang++ #{CXXFLAGS} -o #{mod}.bc #{mod}.cpp"
    puts cmd
    system cmd
  end
end

task :link do
  # Link bitcode files into one bitcode
  cmd = "llvm-ld "
  cmd << "#{LDFLAGS} "
  cmd << "-o #{BINARY} "
  MODULES.each do |mod|
    cmd << "#{mod}.bc "
  end
  LIBDIRS.each do |libdir|
    cmd << "-L#{libdir} "
  end
  LIBS.each do |lib|
    cmd << "-l#{lib} "
  end
  puts cmd
  system cmd
end

task :assembly do
  # Generate assembly code
  cmd = "llc -x86-asm-syntax=att -o #{BINARY}.s #{BINARY}.bc"
  puts cmd
  system cmd
end

task :native do
  # Generate native executable
  cmd = "gcc -fno-strict-aliasing -O3 -o #{BINARY} #{BINARY}.s "
  LIBDIRS.each do |libdir|
    cmd << "-L#{libdir} "
  end
  LIBS.each do |lib|
    cmd << "-l#{lib} "
  end
  puts cmd
  system cmd
end
