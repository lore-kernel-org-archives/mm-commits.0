From: akpm@linux-foundation.org
Subject: + gitignore-update.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:23:13 -0700
Message-ID: <200707052123.l65LND6n020381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760868AbXGEVYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, dwmw2@infradead.org


The patch titled
     .gitignore update
has been added to the -mm tree.  Its filename is
     gitignore-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-arch_pick_mmap_layout-fixlet.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
gitignore-update.patch
