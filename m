From: akpm@linux-foundation.org
Subject: [merged] bio-remove-unused-macro-bip_vec_idx.patch removed from
 -mm tree
Date: Wed, 25 Jun 2014 11:12:34 -0700
Message-ID: <53ab1112.n0oQTw4WCcuUhqdc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaFYSMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 14:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bio.h: remove unused macro bip_vec_idx()
has been removed from the -mm tree.  Its filename was
     bio-remove-unused-macro-bip_vec_idx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: include/linux/bio.h: remove unused macro bip_vec_idx()

Macro bip_vec_idx() was used by bio integrity originally, but no longer
used now. So remove it.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bio.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/bio.h~bio-remove-unused-macro-bip_vec_idx include/linux/bio.h
--- a/include/linux/bio.h~bio-remove-unused-macro-bip_vec_idx
+++ a/include/linux/bio.h
@@ -644,10 +644,6 @@ struct biovec_slab {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-
-
-#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
