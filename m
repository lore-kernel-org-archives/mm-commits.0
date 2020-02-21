From: akpm@linux-foundation.org
Subject: [patch 15/15] MAINTAINERS: use tabs for SAFESETID
Date: Thu, 20 Feb 2020 20:04:33 -0800
Message-ID: <20200221040433.D_YSm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbgBUEEe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, mortonm@chromium.org, jmorris@namei.org, rdunlap@infradead.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: use tabs for SAFESETID

Use tabs for indentation instead of spaces for SAFESETID.  All (!) other
entries in MAINTAINERS use tabs (according to my simple grepping).

Link: http://lkml.kernel.org/r/2bb2e52a-2694-816d-57b4-6cabfadd6c1a@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Micah Morton <mortonm@chromium.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/MAINTAINERS~maintainers-use-tabs-for-safesetid
+++ a/MAINTAINERS
@@ -14582,10 +14582,10 @@ F:	drivers/media/pci/saa7146/
 F:	include/media/drv-intf/saa7146*
 
 SAFESETID SECURITY MODULE
-M:     Micah Morton <mortonm@chromium.org>
-S:     Supported
-F:     security/safesetid/
-F:     Documentation/admin-guide/LSM/SafeSetID.rst
+M:	Micah Morton <mortonm@chromium.org>
+S:	Supported
+F:	security/safesetid/
+F:	Documentation/admin-guide/LSM/SafeSetID.rst
 
 SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
_
