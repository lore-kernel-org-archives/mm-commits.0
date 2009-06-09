From: akpm@linux-foundation.org
Subject: [merged] doc-remove-the-hyphen-from-git-commands.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:37 -0700
Message-ID: <200906091812.n59ICbl0018810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686AbZFISMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraai@ftbfs.org, mm-commits@vger.kernel.org


The patch titled
     doc: remove the hyphen from git commands
has been removed from the -mm tree.  Its filename was
     doc-remove-the-hyphen-from-git-commands.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: remove the hyphen from git commands
From: Matt Kraai <kraai@ftbfs.org>

Semi-recent versions of Git don't support a hyphen between "git" and the
specific command, so remove them from examples that use them.

Signed-off-by: Matt Kraai <kraai@ftbfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore                        |    2 +-
 Documentation/trace/kmemtrace.txt |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN .gitignore~doc-remove-the-hyphen-from-git-commands .gitignore
--- a/.gitignore~doc-remove-the-hyphen-from-git-commands
+++ a/.gitignore
@@ -3,7 +3,7 @@
 # subdirectories here. Add them in the ".gitignore" file
 # in that subdirectory instead.
 #
-# NOTE! Please use 'git-ls-files -i --exclude-standard'
+# NOTE! Please use 'git ls-files -i --exclude-standard'
 # command after changing this file, to see if there are
 # any tracked files which get ignored after the change.
 #
diff -puN Documentation/trace/kmemtrace.txt~doc-remove-the-hyphen-from-git-commands Documentation/trace/kmemtrace.txt
--- a/Documentation/trace/kmemtrace.txt~doc-remove-the-hyphen-from-git-commands
+++ a/Documentation/trace/kmemtrace.txt
@@ -64,7 +64,7 @@ III. Quick usage guide
 CONFIG_KMEMTRACE).
 
 2) Get the userspace tool and build it:
-$ git-clone git://repo.or.cz/kmemtrace-user.git		# current repository
+$ git clone git://repo.or.cz/kmemtrace-user.git		# current repository
 $ cd kmemtrace-user/
 $ ./autogen.sh
 $ ./configure
_

Patches currently in -mm which might be from kraai@ftbfs.org are

linux-next.patch

