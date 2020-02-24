From: akpm@linux-foundation.org
Subject: [merged] maintainers-use-tabs-for-safesetid.patch removed
 from -mm tree
Date: Sun, 23 Feb 2020 16:45:04 -0800
Message-ID: <20200224004504.UWFeacnjQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgBXApF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmorris@namei.org, mm-commits@vger.kernel.org, mortonm@chromium.org, rdunlap@infradead.org, serge@hallyn.com


The patch titled
     Subject: MAINTAINERS: use tabs for SAFESETID
has been removed from the -mm tree.  Its filename was
     maintainers-use-tabs-for-safesetid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are
