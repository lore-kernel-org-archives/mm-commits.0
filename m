From: akpm@osdl.org
Subject: - readme-updated.patch removed from -mm tree
Date: Wed, 06 Dec 2006 18:54:59 -0800
Message-ID: <200612070254.kB72sx7T026542@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40054 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967774AbWLGCzC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 21:55:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xose.vazquez@gmail.com, mm-commits@vger.kernel.org


The patch titled
     README updated
has been removed from the -mm tree.  Its filename was
     readme-updated.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: README updated
From: Xose Vazquez Perez <xose.vazquez@gmail.com>

Updated information about ports.

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 README |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN README~readme-updated README
--- a/README~readme-updated
+++ a/README
@@ -1,4 +1,5 @@
-	Linux kernel release 2.6.xx <http://kernel.org>
+		Linux kernel release 2.6.xx
+		    <http://kernel.org>
 
 These are the release notes for Linux version 2.6.  Read them carefully,
 as they tell you what this is all about, explain how to install the
@@ -21,10 +22,11 @@ WHAT IS LINUX?
 ON WHAT HARDWARE DOES IT RUN?
 
   Although originally developed first for 32-bit x86-based PCs (386 or higher),
-  today Linux also runs on (at least) the Compaq Alpha AXP, Sun SPARC and
+  today Linux also runs on (at least) the Digital Alpha AXP, Sun SPARC and
   UltraSPARC, Motorola 68000, PowerPC, PowerPC64, ARM, Hitachi SuperH,
   IBM S/390, MIPS, HP PA-RISC, Intel IA-64, DEC VAX, AMD x86-64, AXIS CRIS,
-  and Renesas M32R architectures.
+  Renesas M32R, Fujitsu FR-V, and Tensilica Xtensa architectures. For many of
+  these architectures in both 32- and 64-bit variants.
 
   Linux is easily portable to most general-purpose 32- or 64-bit architectures
   as long as they have a paged memory management unit (PMMU) and a port of the
_

Patches currently in -mm which might be from xose.vazquez@gmail.com are

readme-updated.patch

