From: akpm@linux-foundation.org
Subject: + maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch added to -mm tree
Date: Fri, 29 Jun 2012 14:18:55 -0700
Message-ID: <20120629211855.AA178A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35083 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2F2VS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 17:18:56 -0400
Received: by ghbz15 with SMTP id z15so423050ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 14:18:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@ti.com, arnd@arndb.de, rjw@sisk.pl


The patch titled
     Subject: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section
has been added to the -mm tree.  Its filename is
     maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Hilman <khilman@ti.com>
Subject: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section

Add the OMAP CPUFreq driver to the list of files in the OMAP Power
Management section.

I've already been maintaining this driver, this just makes it official.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-omap-cpufreq-driver-to-omap-power-management-section MAINTAINERS
--- a/MAINTAINERS~maintainers-add-omap-cpufreq-driver-to-omap-power-management-section
+++ a/MAINTAINERS
@@ -4866,6 +4866,7 @@ M:	Kevin Hilman <khilman@ti.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
+F:	drivers/cpufreq/omap-cpufreq.c
 
 OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
_
Subject: Subject: MAINTAINERS: add OMAP CPUfreq driver to OMAP Power Management section

Patches currently in -mm which might be from khilman@ti.com are

linux-next.patch
maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch

