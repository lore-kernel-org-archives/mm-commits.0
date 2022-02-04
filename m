Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA3CC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 04:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiBDEtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:49:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243103AbiBDEto (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 23:49:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F28BE61B4C
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 04:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6F2C340E9;
        Fri,  4 Feb 2022 04:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950183;
        bh=ZC4LeS+qrwW4Qth3uKchhgCgE1oEId3KHtX6V15jRjI=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=E7d4KWDjy4P9xpzOPVBHjeUbEuhLDbXW6Qup5bhT15RYVMB9UnEkzaF9zfw8rBqNQ
         59a9xxanEEIk8aeRciBKeY24xOaXUO9nzSdEaFoxhprQb4Q8UQmZsGchPmjwehQJIO
         DrYjzOd7EUdHT7RGIF7dSRwVzEU8uR3kVH7u/hsE=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:41 -0800
Date:   Thu, 03 Feb 2022 20:49:41 -0800
To:     rppt@linux.ibm.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 09/10] MAINTAINERS: update rppt's email
Message-Id: <20220204044942.3F6F2C340E9@smtp.kernel.org>
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
