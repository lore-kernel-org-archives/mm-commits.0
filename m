From: akpm@linux-foundation.org
Subject: [merged] pm-opp-add-entry-in-maintainers.patch removed from -mm
 tree
Date: Mon, 23 Nov 2015 12:15:22 -0800
Message-ID: <565373da.NNGNiX7jfIqKrmHF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbKWUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, rjw@rjwysocki.net, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: PM/OPP: add entry in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     pm-opp-add-entry-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: PM/OPP: add entry in MAINTAINERS

Add entry for operating performance points into MAINTAINERS file.  This
will also allow get_maintainers to list OPP stakeholders properly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rafael Wysocki <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN MAINTAINERS~pm-opp-add-entry-in-maintainers MAINTAINERS
--- a/MAINTAINERS~pm-opp-add-entry-in-maintainers
+++ a/MAINTAINERS
@@ -7903,6 +7903,18 @@ S:	Maintained
 F:	net/openvswitch/
 F:	include/uapi/linux/openvswitch.h
 
+OPERATING PERFORMANCE POINTS (OPP)
+M:	Viresh Kumar <vireshk@kernel.org>
+M:	Nishanth Menon <nm@ti.com>
+M:	Stephen Boyd <sboyd@codeaurora.org>
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/pm.git
+F:	drivers/base/power/opp/
+F:	include/linux/pm_opp.h
+F:	Documentation/power/opp.txt
+F:	Documentation/devicetree/bindings/opp/
+
 OPL4 DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are


