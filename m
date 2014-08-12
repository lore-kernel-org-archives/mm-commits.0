From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-microcode-patterns.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:03 -0700
Message-ID: <53ea6e47.1Ki5fOX4Kii3z3xh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:41334 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHLTnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:04 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919932oah.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update microcode patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-microcode-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update microcode patterns

Commit bad5fa631fca ("x86, microcode: Move to a proper location") moved
the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-microcode-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-microcode-patterns
+++ a/MAINTAINERS
@@ -621,7 +621,7 @@ AMD MICROCODE UPDATE SUPPORT
 M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	amd64-microcode@amd64.org
 S:	Maintained
-F:	arch/x86/kernel/microcode_amd.c
+F:	arch/x86/kernel/cpu/microcode/amd*
 
 AMD XGBE DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
@@ -4692,8 +4692,8 @@ F:	drivers/platform/x86/intel_menlow.c
 INTEL IA32 MICROCODE UPDATE SUPPORT
 M:	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
 S:	Maintained
-F:	arch/x86/kernel/microcode_core.c
-F:	arch/x86/kernel/microcode_intel.c
+F:	arch/x86/kernel/cpu/microcode/core*
+F:	arch/x86/kernel/cpu/microcode/intel*
 
 INTEL I/OAT DMA DRIVER
 M:	Dan Williams <dan.j.williams@intel.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

