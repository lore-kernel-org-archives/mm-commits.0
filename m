From: akpm@linux-foundation.org
Subject: - gitignore-ignore-emacs-backup-and-temporary-files.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:00 -0800
Message-ID: <200803050745.m257j02h021553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764812AbYCEHpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@mips.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     .gitignore: ignore emacs backup and temporary files.
has been removed from the -mm tree.  Its filename was
     gitignore-ignore-emacs-backup-and-temporary-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-try-both-endianess-when-checking-for-endianess.patch

