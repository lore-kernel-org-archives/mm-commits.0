From: akpm@linux-foundation.org
Subject: + doc-remove-the-hyphen-from-git-commands.patch added to -mm tree
Date: Fri, 05 Jun 2009 12:56:07 -0700
Message-ID: <200906051956.n55Ju7wI005302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZFET4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 15:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraai@ftbfs.org


The patch titled
     doc: remove the hyphen from git commands
has been added to the -mm tree.  Its filename is
     doc-remove-the-hyphen-from-git-commands.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

doc-remove-the-hyphen-from-git-commands.patch

