From: akpm@linux-foundation.org
Subject: + update-maintainers-for-drm-sti-driver.patch added to -mm tree
Date: Thu, 13 Aug 2015 14:19:23 -0700
Message-ID: <55cd09db.oKgpYdHKCCNn6F5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbHMVTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Aug 2015 17:19:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benjamin.gaignard@linaro.org, airlied@linux.ie, vincent.abriou@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Update maintainers for DRM STI driver
has been added to the -mm tree.  Its filename is
     update-maintainers-for-drm-sti-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-maintainers-for-drm-sti-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-maintainers-for-drm-sti-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

update-maintainers-for-drm-sti-driver.patch

