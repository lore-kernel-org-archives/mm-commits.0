From: akpm@linux-foundation.org
Subject: [merged] gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:11 -0700
Message-ID: <200909232004.n8NK4B2P020736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbZIWULC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma
has been removed from the -mm tree.  Its filename was
     gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma are binary
files should be ignored

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff -puN usr/.gitignore~gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma usr/.gitignore
--- a/usr/.gitignore~gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma
+++ a/usr/.gitignore
@@ -4,5 +4,7 @@
 gen_init_cpio
 initramfs_data.cpio
 initramfs_data.cpio.gz
+initramfs_data.cpio.bz2
+initramfs_data.cpio.lzma
 initramfs_list
 include
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
includecheck-fix-documentation-cfag12864b-examplec.patch

