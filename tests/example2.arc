# Main script
var repos = updateUsing({git : "E:\\Repos\\GIT", hg : "E:\\Repos\\HG", svn : "E:\\Repos\\SVN"});
WriteLn(repos);
System("PAUSE");

def updateUsing(args: Array)
do
  var dirs = Array.new();
  for var pair in args
  do
    var cmd = "PAUSE";
    case pair.Key
      when git do cmd = "git pull"; end
      when hg  do cmd = "hg up"; end
      when svn do cmd = "svn up"; end
    else
      WriteLn("CVS nao reconhecido");
      System(cmd);
      exit;
    end
    WriteLn("=== ${pair.Key}:up");
    System.Directory.Chan;
    var subRepos = System.Directory.ListDirectories;
    for var subRepo in subRepos
    do
      WriteLn(">>> ${subRepo}");
      System.Directory.Chan;
      System(cmd);
      WriteLn("<<< ${subRepo}");
      System.Directory.Chan;
      WriteLn;
      dirs.Add("${pair.Value}\\${subRepo}");
    end
  end
  Result = dirs;
end
