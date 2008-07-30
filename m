From: akpm@linux-foundation.org
Subject: - gru-driver-v3-driver-makefile.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:09 -0700
Message-ID: <200807301916.m6UJG9QD011100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbYG3TXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU Driver: driver makefile
has been removed from the -mm tree.  Its filename was
     gru-driver-v3-driver-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU Driver: driver makefile
From: Jack Steiner <steiner@sgi.com>

This patch adds the GRU driver makefile

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN /dev/null drivers/misc/sgi-gru/Makefile
--- /dev/null
+++ a/drivers/misc/sgi-gru/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SGI_GRU) := gru.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch

