Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA62C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbiDDXKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240973AbiDDXJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616B0F67
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 15:43:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA027616A0
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 22:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43935C2BBE4;
        Mon,  4 Apr 2022 22:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649112225;
        bh=eTcvO+om6LwI8EBoxMiuK24UUmqm/MQOtxp+VupFDmE=;
        h=Date:To:From:Subject:From;
        b=0XvjeZ7LDNID6odQtXWTS3uzYPXInRJsBsmWIcKF02XtyMVPeBXcRu+2fyfuQzYqK
         rAUP2P7vWotyoG92zTOhDgLSQCIpVytowdzzffXSPOKyAw4NN6M8GZBnw21cXQ4i35
         32QdrM7nuGBYPUrZBrIuzBGhVoMgKm1gvJYjfURI=
Date:   Mon, 04 Apr 2022 15:43:44 -0700
To:     mm-commits@vger.kernel.org, ismael@iodev.co.uk,
        thomas.orgis@uni-hamburg.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-version-12-with-thread-group-and-exe-info-fix.patch added to -mm tree
Message-Id: <20220404224345.43935C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-version-12-with-thread-group-and-exe-info-fix
has been added to the -mm tree.  Its filename is
     taskstats-version-12-with-thread-group-and-exe-info-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/taskstats-version-12-with-thread-group-and-exe-info-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/taskstats-version-12-with-thread-group-and-exe-info-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Subject: taskstats-version-12-with-thread-group-and-exe-info-fix

fix version number in comment

Link: https://lkml.kernel.org/r/20220405003601.7a5f6008@plasteblaster
Signed-off-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Reviewed-by: Ismael Luceno <ismael@iodev.co.uk>
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
taskstats-version-12-with-thread-group-and-exe-info-fix.patch

