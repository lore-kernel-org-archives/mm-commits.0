From: akpm@linux-foundation.org
Subject: [patch 073/102] config/android: Remove CONFIG_IPV6_PRIVACY
Date: Tue, 11 Oct 2016 13:54:36 -0700
Message-ID: <57fd518c.zxQL27w3BrUXAn2d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbcJKUyh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bp@suse.de, robh@kernel.org

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
