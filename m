From: akpm@linux-foundation.org
Subject: + thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:36:06 -0700
Message-ID: <200910282236.n9SMa6Dw021200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbZJ1Wgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, sujith.thomas@intel.com


The patch titled
     thermal: sysfs-api.txt - document passive attribute for thermal zones
has been added to the -mm tree.  Its filename is
     thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: sysfs-api.txt - document passive attribute for thermal zones
From: Frans Pop <elendil@planet.nl>

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/thermal/sysfs-api.txt~thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones Documentation/thermal/sysfs-api.txt
--- a/Documentation/thermal/sysfs-api.txt~thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones
+++ a/Documentation/thermal/sysfs-api.txt
@@ -199,6 +199,15 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones in which the passive cooling
+	policy is not supported by native thermal driver. Default is zero
+	and can be set to a temperature (in millidegrees) to enable a
+	passive trip point for the zone. Activation is done by polling with
+	an interval of 1 second.
+	Unit: millidegrees Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
thermal-sysfs-apitxt-reformat-for-improved-readability.patch
thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
thermal-add-sanity-check-for-the-passive-attribute.patch
thermal-only-set-passive_delay-for-forced_passive-cooling.patch
thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

