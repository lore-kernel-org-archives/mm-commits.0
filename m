Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE4BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379674AbiD2UxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347507AbiD2UxN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:53:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434B3852D4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E414BB837B8
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1017C385A4;
        Fri, 29 Apr 2022 20:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651265391;
        bh=OAoFzg9l3K1OJbSJB69CHRieaTY9ojEdRYyngzc2bJ0=;
        h=Date:To:From:Subject:From;
        b=w7lhq7mSz/rRpVWwLMuJUXQ+fx2j9TqXAJkxOpOmSeZzqUAe9OzrJ3BuPlm8ilQk9
         PmZA2T+b8R4z0h6V2SDBISGleykEnwgh1ukwc0nc9yQ/64x1cWtzZ5W4JjkXhOTje1
         eT7lHmCHWTJz8I1FJFcE0i2OLoiLUl7gLUx4xF6M=
Date:   Fri, 29 Apr 2022 13:49:51 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn, ismael@iodev.co.uk, ebiederm@xmission.com,
        bsingharora@gmail.com, thomas.orgis@uni-hamburg.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] taskstats-version-12-with-thread-group-and-exe-info-fix.patch removed from -mm tree
Message-Id: <20220429204951.A1017C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: taskstats-version-12-with-thread-group-and-exe-info-fix
has been removed from the -mm tree.  Its filename was
     taskstats-version-12-with-thread-group-and-exe-info-fix.patch

This patch was dropped because it was folded into taskstats-version-12-with-thread-group-and-exe-info.patch

------------------------------------------------------
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: taskstats-version-12-with-thread-group-and-exe-info-fix

fix version number in comment

Link: https://lkml.kernel.org/r/20220405003601.7a5f6008@plasteblaster
Signed-off-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Reviewed-by: Ismael Luceno <ismael@iodev.co.uk>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/taskstats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/taskstats.h~taskstats-version-12-with-thread-group-and-exe-info-fix
+++ a/include/uapi/linux/taskstats.h
@@ -49,7 +49,7 @@ struct taskstats {
 
 	/* The accounting flags of a task as defined in <linux/acct.h>
 	 * Defined values are AFORK, ASU, ACOMPAT, ACORE, AXSIG, and AGROUP.
-	 * (AGROUP since version 11).
+	 * (AGROUP since version 12).
 	 */
 	__u8	ac_flag;		/* Record flags */
 	__u8	ac_nice;		/* task_nice */
_

Patches currently in -mm which might be from thomas.orgis@uni-hamburg.de are

taskstats-version-12-with-thread-group-and-exe-info.patch

