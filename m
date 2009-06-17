From: akpm@linux-foundation.org
Subject: [merged] drbd-add-major-number-to-majorh.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:19 -0700
Message-ID: <200906171837.n5HIbJFL003316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759081AbZFQSqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.reisner@linbit.com, lars.ellenberg@linbit.com, mm-commits@vger.kernel.org


The patch titled
     drbd: add major number to major.h
has been removed from the -mm tree.  Its filename was
     drbd-add-major-number-to-majorh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drbd: add major number to major.h
From: Philipp Reisner <philipp.reisner@linbit.com>

Since we have had a LANANA major number for years, and it is documented in
devices.txt, I think that this first patch can go upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/major.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/major.h~drbd-add-major-number-to-majorh include/linux/major.h
--- a/include/linux/major.h~drbd-add-major-number-to-majorh
+++ a/include/linux/major.h
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
_

Patches currently in -mm which might be from philipp.reisner@linbit.com are

origin.patch

