From: akpm@linux-foundation.org
Subject: + gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:26:40 -0700
Message-ID: <200906301926.n5UJQek9018547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbZF3T21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, jaswinderrajput@gmail.com, sam@ravnborg.org


The patch titled
     gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma
has been added to the -mm tree.  Its filename is
     gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch

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
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch

