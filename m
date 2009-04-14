From: akpm@linux-foundation.org
Subject: [merged] setlocalversion-use-git-svn-instead-of-git-svn.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:48 -0700
Message-ID: <200904141950.n3EJomZY020358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145AbZDNTxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     setlocalversion: use git svn instead of git-svn
has been removed from the -mm tree.  Its filename was
     setlocalversion-use-git-svn-instead-of-git-svn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: setlocalversion: use git svn instead of git-svn
From: Peter Korsgaard <jacmet@sunsite.dk>

Use the correct git <subcmd> syntax instead of the deprecated git-<subcmd>.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/setlocalversion |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/setlocalversion~setlocalversion-use-git-svn-instead-of-git-svn scripts/setlocalversion
--- a/scripts/setlocalversion~setlocalversion-use-git-svn-instead-of-git-svn
+++ a/scripts/setlocalversion
@@ -21,7 +21,7 @@ if head=`git rev-parse --verify --short 
 
 	# Is this git on svn?
 	if git config --get svn-remote.svn.url >/dev/null; then
-	        printf -- '-svn%s' "`git-svn find-rev $head`"
+	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
 	# Are there uncommitted changes?
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch
linux-next.patch

