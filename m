From: akpm@linux-foundation.org
Subject: + gitignore-ignore-emacs-backup-and-temporary-files.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:32:55 -0800
Message-ID: <200802280332.m1S3Wtpf013530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbYB1DdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris@mips.com, ralf@linux-mips.org


The patch titled
     .gitignore: ignore emacs backup and temporary files.
has been added to the -mm tree.  Its filename is
     gitignore-ignore-emacs-backup-and-temporary-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: .gitignore: ignore emacs backup and temporary files.
From: Chris Dearman <chris@mips.com>

Signed-off-by: Chris Dearman <chris@mips.com>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff -puN .gitignore~gitignore-ignore-emacs-backup-and-temporary-files .gitignore
--- a/.gitignore~gitignore-ignore-emacs-backup-and-temporary-files
+++ a/.gitignore
@@ -53,3 +53,5 @@ cscope.*
 
 *.orig
 *.rej
+*~
+\#*#
_

Patches currently in -mm which might be from chris@mips.com are

gitignore-ignore-emacs-backup-and-temporary-files.patch
mm-try-both-endianess-when-checking-for-endianess.patch
