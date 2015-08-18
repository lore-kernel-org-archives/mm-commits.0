From: akpm@linux-foundation.org
Subject: [merged] update-maintainers-for-drm-sti-driver.patch removed from -mm tree
Date: Tue, 18 Aug 2015 12:42:40 -0700
Message-ID: <55d38ab0.1yT+GgmnJPthMHAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbbHRTmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Aug 2015 15:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benjamin.gaignard@linaro.org, airlied@linux.ie, vincent.abriou@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Update maintainers for DRM STI driver
has been removed from the -mm tree.  Its filename was
     update-maintainers-for-drm-sti-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Update maintainers for DRM STI driver

Add Vincent Abriou and myself as maintainers.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Vincent Abriou <vincent.abriou@st.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~update-maintainers-for-drm-sti-driver MAINTAINERS
--- a/MAINTAINERS~update-maintainers-for-drm-sti-driver
+++ a/MAINTAINERS
@@ -3587,6 +3587,15 @@ S:	Maintained
 F:	drivers/gpu/drm/rockchip/
 F:	Documentation/devicetree/bindings/video/rockchip*
 
+DRM DRIVERS FOR STI
+M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
+M:	Vincent Abriou <vincent.abriou@st.com>
+L:	dri-devel@lists.freedesktop.org
+T:	git http://git.linaro.org/people/benjamin.gaignard/kernel.git
+S:	Maintained
+F:	drivers/gpu/drm/sti
+F:	Documentation/devicetree/bindings/gpu/st,stih4xx.txt
+
 DSBR100 USB FM RADIO DRIVER
 M:	Alexey Klimov <klimov.linux@gmail.com>
 L:	linux-media@vger.kernel.org
_

Patches currently in -mm which might be from benjamin.gaignard@linaro.org are

linux-next.patch

