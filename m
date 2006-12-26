From: akpm@osdl.org
Subject: - forcedeth-modified-comment-header.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:00 -0800
Message-ID: <200612262319.kBQNJ04B027775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37409 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbWLZXTD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: modified comment header
has been removed from the -mm tree.  Its filename was
     forcedeth-modified-comment-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: modified comment header
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch removes comment that forcedeth is not supported by NVIDIA.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-modified-comment-header drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-modified-comment-header
+++ a/drivers/net/forcedeth.c
@@ -3,8 +3,7 @@
  *
  * Note: This driver is a cleanroom reimplementation based on reverse
  *      engineered documentation written by Carl-Daniel Hailfinger
- *      and Andrew de Quincey. It's neither supported nor endorsed
- *      by NVIDIA Corp. Use at your own risk.
+ *      and Andrew de Quincey.
  *
  * NVIDIA, nForce and other NVIDIA marks are trademarks or registered
  * trademarks of NVIDIA Corporation in the United States and other
@@ -14,7 +13,7 @@
  * Copyright (C) 2004 Andrew de Quincey (wol support)
  * Copyright (C) 2004 Carl-Daniel Hailfinger (invalid MAC handling, insane
  *		IRQ rate fixes, bigendian fixes, cleanups, verification)
- * Copyright (c) 2004 NVIDIA Corporation
+ * Copyright (c) 2004,5,6 NVIDIA Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch

