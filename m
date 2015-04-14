From: akpm@linux-foundation.org
Subject: [folded-merged] x86-mm-support-huge-kva-mappings-on-x86-fix.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:18:09 -0700
Message-ID: <552d9221.PHFTOYcmlUzTxr24%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbbDNWSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, toshi.kani@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: ioremap_pud_capable can be static
has been removed from the -mm tree.  Its filename was
     x86-mm-support-huge-kva-mappings-on-x86-fix.patch

This patch was dropped because it was folded into x86-mm-support-huge-kva-mappings-on-x86.patch

------------------------------------------------------
From: kbuild test robot <fengguang.wu@intel.com>
Subject: x86, mm: ioremap_pud_capable can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86-fix lib/ioremap.c
--- a/lib/ioremap.c~x86-mm-support-huge-kva-mappings-on-x86-fix
+++ a/lib/ioremap.c
@@ -14,9 +14,9 @@
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-int __read_mostly ioremap_pud_capable;
-int __read_mostly ioremap_pmd_capable;
-int __read_mostly ioremap_huge_disabled;
+static int __read_mostly ioremap_pud_capable;
+static int __read_mostly ioremap_pmd_capable;
+static int __read_mostly ioremap_huge_disabled;
 
 static int __init set_nohugeiomap(char *str)
 {
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

