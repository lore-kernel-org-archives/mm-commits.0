From: akpm@linux-foundation.org
Subject: + config-android-remove-config_ipv6_privacy.patch added to -mm
 tree
Date: Thu, 11 Aug 2016 13:50:18 -0700
Message-ID: <57ace50a.GRpbtEwLPhvzAEaT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcHKUuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 16:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, robh@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: config/android: Remove CONFIG_IPV6_PRIVACY
has been added to the -mm tree.  Its filename is
     config-android-remove-config_ipv6_privacy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/config-android-remove-config_ipv6_privacy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/config-android-remove-config_ipv6_privacy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: config/android: Remove CONFIG_IPV6_PRIVACY

Option is long gone, see

  5d9efa7ee99e ("ipv6: Remove privacy config option.")

Link: http://lkml.kernel.org/r/20160811170340.9859-1-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/android-base.config |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/configs/android-base.config~config-android-remove-config_ipv6_privacy kernel/configs/android-base.config
--- a/kernel/configs/android-base.config~config-android-remove-config_ipv6_privacy
+++ a/kernel/configs/android-base.config
@@ -41,7 +41,6 @@ CONFIG_IPV6=y
 CONFIG_IPV6_MIP6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_IPV6_OPTIMISTIC_DAD=y
-CONFIG_IPV6_PRIVACY=y
 CONFIG_IPV6_ROUTER_PREF=y
 CONFIG_IPV6_ROUTE_INFO=y
 CONFIG_IP_ADVANCED_ROUTER=y
_

Patches currently in -mm which might be from bp@suse.de are

config-android-remove-config_ipv6_privacy.patch

