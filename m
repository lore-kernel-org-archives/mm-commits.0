Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B99C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 17:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377212AbiBDR5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377211AbiBDR5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2022 12:57:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B920DC061714
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 09:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A152B83830
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 17:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225A3C004E1;
        Fri,  4 Feb 2022 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643997436;
        bh=ZC4LeS+qrwW4Qth3uKchhgCgE1oEId3KHtX6V15jRjI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=fw9uVy4a2mpV6rnjKWpaEnYFO2k2BovNqs2uX7rjXMdu4/daMe1msEW7hq+y8O5qN
         d0y6m5EVFwZn0KE9TKVI12OIjifx7S19JBmZATT6A/A2GoXaCQSIsbrwJNUpV1BXQl
         zZnQ4hUUsnDcfinsdWfVvh+g2ZpHlO2RYUnlpnNw=
Received: by hp1 (sSMTP sendmail emulation); Fri, 04 Feb 2022 09:57:14 -0800
Date:   Fri, 04 Feb 2022 09:57:14 -0800
To:     rppt@linux.ibm.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 09/10] MAINTAINERS: update rppt's email
Message-Id: <20220204175715.225A3C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: MAINTAINERS: update rppt's email

Use my @kernel.org address

Link: https://lkml.kernel.org/r/20220203090324.3701774-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-rppts-email
+++ a/MAINTAINERS
@@ -12400,7 +12400,7 @@ F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
 MEMBLOCK
-M:	Mike Rapoport <rppt@linux.ibm.com>
+M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/core-api/boot-time-mm.rst
_
