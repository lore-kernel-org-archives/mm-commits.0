From: akpm@linux-foundation.org
Subject: [merged] viafb-documentation-update.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:32 -0800
Message-ID: <200912162036.nBGKaW2J013249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935442AbZLPUgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: documentation update
has been removed from the -mm tree.  Its filename was
     viafb-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: documentation update
From: Harald Welte <laforge@gnumonks.org>

We now support the VX855, and the VX800 is no longer unaccellerated.
viafb_video_dev was removed as it was useless.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/viafb.txt |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN Documentation/fb/viafb.txt~viafb-documentation-update Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt~viafb-documentation-update
+++ a/Documentation/fb/viafb.txt
@@ -7,7 +7,7 @@
     VIA UniChrome Family(CLE266, PM800 / CN400 / CN300,
                         P4M800CE / P4M800Pro / CN700 / VN800,
                         CX700 / VX700, K8M890, P4M890,
-                        CN896 / P4M900, VX800)
+                        CN896 / P4M900, VX800, VX855)
 
 [Driver features]
 ------------------------
@@ -154,13 +154,6 @@
         0 : No Dual Edge Panel (default)
         1 : Dual Edge Panel
 
-    viafb_video_dev:
-        This option is used to specify video output devices(CRT, DVI, LCD) for
-        duoview case.
-        For example:
-        To output video on DVI, we should use:
-            modprobe viafb viafb_video_dev=DVI...
