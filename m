From: akpm@linux-foundation.org
Subject: + pm-opp-add-entry-in-maintainers.patch added to -mm tree
Date: Wed, 18 Nov 2015 12:56:52 -0800
Message-ID: <564ce614.b0ZJsJLy9jKGalLs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbbKRU4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 15:56:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, rjw@rjwysocki.net, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: PM/OPP: add entry in MAINTAINERS
has been added to the -mm tree.  Its filename is
     pm-opp-add-entry-in-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pm-opp-add-entry-in-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pm-opp-add-entry-in-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7902,6 +7902,18 @@ S:	Maintained
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

pm-opp-add-entry-in-maintainers.patch

