From: akpm@linux-foundation.org
Subject: + maintainers-use-tabs-for-safesetid.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 14:57:47 -0800
Message-ID: <20200219225747.fRh7v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727636AbgBSW5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 17:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge@hallyn.com, mortonm@chromium.org, jmorris@namei.org, rdunlap@infradead.org


The patch titled
     Subject: MAINTAINERS: use tabs for SAFESETID
has been added to the -mm tree.  Its filename is
     maintainers-use-tabs-for-safesetid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-use-tabs-for-safesetid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-use-tabs-for-safesetid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-use-tabs-for-safesetid.patch
