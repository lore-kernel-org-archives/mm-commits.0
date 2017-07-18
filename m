From: akpm@linux-foundation.org
Subject: + maintainers-move-avs-drivers-entry.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:41:18 -0700
Message-ID: <596e8e8e.1flJhjA1SqWw4Oit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53158 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdGRWlT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, khilman@kernel.org, nm@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: move AVS drivers entry
has been added to the -mm tree.  Its filename is
     maintainers-move-avs-drivers-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-move-avs-drivers-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-move-avs-drivers-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
