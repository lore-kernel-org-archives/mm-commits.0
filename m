From: akpm@linux-foundation.org
Subject: [merged] sound-remove-reference-to-feature-removal-scheduletxt.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:46 -0800
Message-ID: <20121218200246.AA733100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50185 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LRUCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:47 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so125221vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: remove reference to feature-removal-schedule.txt
has been removed from the -mm tree.  Its filename was
     sound-remove-reference-to-feature-removal-scheduletxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: sound: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/Kconfig      |    3 ---
 sound/sound_core.c |    3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN sound/Kconfig~sound-remove-reference-to-feature-removal-scheduletxt sound/Kconfig
--- a/sound/Kconfig~sound-remove-reference-to-feature-removal-scheduletxt
+++ a/sound/Kconfig
@@ -52,9 +52,6 @@ config SOUND_OSS_CORE_PRECLAIM
 
 	  Disabling this allows alternative OSS implementations.
 
-	  Please read Documentation/feature-removal-schedule.txt for
-	  details.
