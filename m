From: akpm@osdl.org
Subject: - i386-correct-documentation-for-bzimage-protocol-v205.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:56 -0800
Message-ID: <200612062223.kB6MNuNG018569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937732AbWLFWYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     i386: Correct documentation for bzImage protocol v2.05
has been removed from the -mm tree.  Its filename was
     i386-correct-documentation-for-bzimage-protocol-v205.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Correct documentation for bzImage protocol v2.05
From: Vivek Goyal <vgoyal@in.ibm.com>

Correct the documentation for bzImage protocol extension due to relocatable
bzImage.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/i386/boot.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/i386/boot.txt~i386-correct-documentation-for-bzimage-protocol-v205 Documentation/i386/boot.txt
--- a/Documentation/i386/boot.txt~i386-correct-documentation-for-bzimage-protocol-v205
+++ a/Documentation/i386/boot.txt
@@ -2,7 +2,7 @@
 		     ----------------------------
 
 		    H. Peter Anvin <hpa@zytor.com>
-			Last update 2005-09-02
+			Last update 2006-11-17
 
 On the i386 platform, the Linux kernel uses a rather complicated boot
 convention.  This has evolved partially due to historical aspects, as
@@ -131,8 +131,8 @@ Offset	Proto	Name		Meaning
 0226/2	N/A	pad1		Unused
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
 022C/4	2.03+	initrd_addr_max	Highest legal initrd address
-0230/4	2.04+	kernel_alignment Physical addr alignment required for kernel
-0234/1	2.04+	relocatable_kernel Whether kernel is relocatable or not
+0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
+0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

kexec--kdump-unify-elf-note-code.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch

