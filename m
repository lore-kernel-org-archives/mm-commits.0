From: akpm@linux-foundation.org
Subject: [merged] gru-update-driver-version-number.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:13 -0800
Message-ID: <200912162041.nBGKfDN3013718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965031AbZLPUlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: update driver version number
has been removed from the -mm tree.  Its filename was
     gru-update-driver-version-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: update driver version number
From: Jack Steiner <steiner@sgi.com>

Update the version number of the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grutables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grutables.h~gru-update-driver-version-number drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-update-driver-version-number
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -161,7 +161,7 @@ extern unsigned int gru_max_gids;
 #define GRU_MAX_GRUS		(GRU_MAX_BLADES * GRU_CHIPLETS_PER_BLADE)
 
 #define GRU_DRIVER_ID_STR	"SGI GRU Device Driver"
-#define GRU_DRIVER_VERSION_STR	"0.80"
+#define GRU_DRIVER_VERSION_STR	"0.85"
 
 /*
  * GRU statistics.
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

