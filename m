From: akpm@linux-foundation.org
Subject: [folded-merged] x86-use-generic-early-mem-copy-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:44:10 -0700
Message-ID: <55ef56aa.s749cWONNdUn8zpW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbIHVoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, msalter@redhat.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-use-generic-early-mem-copy-fix
has been removed from the -mm tree.  Its filename was
     x86-use-generic-early-mem-copy-fix.patch

This patch was dropped because it was folded into x86-use-generic-early-mem-copy.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-use-generic-early-mem-copy-fix

remove MAX_MAP_CHUNK define, per Yinghai Lu

Cc: Mark Salter <msalter@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/setup.c~x86-use-generic-early-mem-copy-fix arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-use-generic-early-mem-copy-fix
+++ a/arch/x86/kernel/setup.c
@@ -317,7 +317,6 @@ static u64 __init get_ramdisk_size(void)
 	return ramdisk_size;
 }
 
-#define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
 	/* Assume only end is not page aligned */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
x86-use-generic-early-mem-copy.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

