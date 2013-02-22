From: akpm@linux-foundation.org
Subject: [merged] video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:40 -0800
Message-ID: <20130222203840.AC9A131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33909 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:41 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103555qcs.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, t.figa@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: s3c-fb: add the bit definitions for CSC EQ709 and EQ601
has been removed from the -mm tree.  Its filename was
     video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: s3c-fb: add the bit definitions for CSC EQ709 and EQ601

Add the bit definitions for CSC EQ709 and EQ601.  These definitons are
used to control the CSC parameter such as equation 709 and equation 601.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/samsung_fimd.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/video/samsung_fimd.h~video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601 include/video/samsung_fimd.h
--- a/include/video/samsung_fimd.h~video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601
+++ a/include/video/samsung_fimd.h
@@ -176,6 +176,8 @@
 /* WINCONx */
 
 #define WINCON(_win)				(0x20 + ((_win) * 4))
+#define WINCONx_CSCCON_EQ601			(0x0 << 28)
+#define WINCONx_CSCCON_EQ709			(0x1 << 28)
 #define WINCONx_CSCWIDTH_MASK			(0x3 << 26)
 #define WINCONx_CSCWIDTH_SHIFT			26
 #define WINCONx_CSCWIDTH_WIDE			(0x0 << 26)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

