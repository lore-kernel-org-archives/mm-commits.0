From: akpm@linux-foundation.org
Subject: [alternative-merged]
 maintainers-move-avs-drivers-entry.patch removed from -mm tree
Date: Mon, 24 Jul 2017 13:34:31 -0700
Message-ID: <20170724203431.KF1JdW93k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39930 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753495AbdGXUec (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2017 16:34:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@kernel.org, mm-commits@vger.kernel.org, nm@ti.com, rdunlap@infradead.org


The patch titled
     Subject: MAINTAINERS: move AVS drivers entry
has been removed from the -mm tree.  Its filename was
     maintainers-move-avs-drivers-entry.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: move AVS drivers entry

Move ADAPTIVE VOLTAGE SCALING (AVS) DRIVERS into the 'A' area instead
"DRIVERS FOR ...  (AVS)".  The use of "^DRIVERS FOR ..." should be
discouraged since that would group many unrelated drivers into that
alphabetical listing.

Link: http://lkml.kernel.org/r/629725a1-7619-8151-a6ea-1069b882dd27@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~maintainers-move-avs-drivers-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-move-avs-drivers-entry
+++ a/MAINTAINERS
@@ -407,6 +407,14 @@ W:	http://ez.analog.com/community/linux-
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
+ADAPTIVE VOLTAGE SCALING (AVS) DRIVERS
+M:	Kevin Hilman <khilman@kernel.org>
+M:	Nishanth Menon <nm@ti.com>
+S:	Maintained
+F:	drivers/power/avs/
+F:	include/linux/power/smartreflex.h
+L:	linux-pm@vger.kernel.org
+
 ADDRESS SPACE LAYOUT RANDOMIZATION (ASLR)
 M:	Jiri Kosina <jikos@kernel.org>
 S:	Maintained
@@ -12263,14 +12271,6 @@ S:	Maintained
 F:	Documentation/admin-guide/LSM/Smack.rst
 F:	security/smack/
 
-DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
-M:	Kevin Hilman <khilman@kernel.org>
-M:	Nishanth Menon <nm@ti.com>
-S:	Maintained
-F:	drivers/power/avs/
-F:	include/linux/power/smartreflex.h
-L:	linux-pm@vger.kernel.org
