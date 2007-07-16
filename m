From: akpm@linux-foundation.org
Subject: - gitignore-update.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:23 -0700
Message-ID: <200707162059.l6GKxNuh002424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755651AbXGPVLj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:11:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     .gitignore update
has been removed from the -mm tree.  Its filename was
     gitignore-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: .gitignore update
From: Alexey Dobriyan <adobriyan@sw.ru>

headers_install by default puts headers into usr/include/ .
They're auto-generated, so should be ignored.

Same for *.orig, *.rej .

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore     |    3 +++
 usr/.gitignore |    1 +
 2 files changed, 4 insertions(+)

diff -puN .gitignore~gitignore-update .gitignore
--- a/.gitignore~gitignore-update
+++ a/.gitignore
@@ -45,3 +45,6 @@ series
 
 # cscope files
 cscope.*
+
+*.orig
+*.rej
diff -puN usr/.gitignore~gitignore-update usr/.gitignore
--- a/usr/.gitignore~gitignore-update
+++ a/usr/.gitignore
@@ -5,3 +5,4 @@ gen_init_cpio
 initramfs_data.cpio
 initramfs_data.cpio.gz
 initramfs_list
+include
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-sparse-false-positives-re-bug_onptr.patch
