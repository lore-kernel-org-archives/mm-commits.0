From: akpm@linux-foundation.org
Subject: [merged] maintainers-change-x86-microcode-loader-maintainer.patch removed from -mm tree
Date: Fri, 03 Apr 2015 12:11:45 -0700
Message-ID: <551ee5f1.TJkxXWYfyhW7QzaT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbbDCTLq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 15:11:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, akpm@linux-foundation.org, aravind.gopalakrishnan@amd.com, geert@linux-m68k.org, gregkh@linuxfoundation.org, herrmann.der.user@googlemail.com, mingo@kernel.org, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: change x86 microcode loader maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-change-x86-microcode-loader-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: MAINTAINERS: change x86 microcode loader maintainer

Let's make it official - I've been doing this for a while now anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-change-x86-microcode-loader-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-change-x86-microcode-loader-maintainer
+++ a/MAINTAINERS
@@ -637,8 +637,7 @@ F:      drivers/gpu/drm/radeon/radeon_kf
 F:      include/uapi/linux/kfd_ioctl.h
 
 AMD MICROCODE UPDATE SUPPORT
-M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
-L:	amd64-microcode@amd64.org
+M:	Borislav Petkov <bp@alien8.de>
 S:	Maintained
 F:	arch/x86/kernel/cpu/microcode/amd*
 
@@ -5095,7 +5094,7 @@ S:	Supported
 F:	drivers/platform/x86/intel_menlow.c
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
-M:	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+M:	Borislav Petkov <bp@alien8.de>
 S:	Maintained
 F:	arch/x86/kernel/cpu/microcode/core*
 F:	arch/x86/kernel/cpu/microcode/intel*
_

Patches currently in -mm which might be from bp@suse.de are

origin.patch
mm-trivial-simplify-flag-check.patch
printk-comment-pr_cont-stating-it-is-only-to-continue-a-line.patch
linux-next.patch

