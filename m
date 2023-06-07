Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB0FC77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjFGUA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjFGUAV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1669B2116
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 13:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7FA46429C
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 20:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B938C433EF;
        Wed,  7 Jun 2023 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168017;
        bh=9reksq/MZdaLjfDIpecHGFF3zW3U7xDnpIZvm0JM4jo=;
        h=Date:To:From:Subject:From;
        b=08w/f3EX5sW4W+NCKlOGooNMuYP/DT+f7KNT3cySNHE6+mQAFG0qvBxTP5UQ5RHOp
         Sqak6Wmnu4Ip50B0i7cmScQ8m4Hf9l6eiujF+U/bug8eK8vOSIx371MhtlgNIPWdrn
         eNPNgqBMtr3UKTol2qf4ohjZpN1Hin35herDVrFA=
Date:   Wed, 07 Jun 2023 13:00:16 -0700
To:     mm-commits@vger.kernel.org, john@keeping.me.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-john-keeping.patch removed from -mm tree
Message-Id: <20230607200017.4B938C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for John Keeping
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-john-keeping.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Keeping <john@keeping.me.uk>
Subject: mailmap: add entry for John Keeping
Date: Wed, 31 May 2023 15:48:39 +0100

Map my corporate address to my personal one, as I am leaving the
company.

Link: https://lkml.kernel.org/r/20230531144839.1157112-1-john@keeping.me.uk
Signed-off-by: John Keeping <john@keeping.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-john-keeping
+++ a/.mailmap
@@ -233,6 +233,7 @@ Jisheng Zhang <jszhang@kernel.org> <Jish
 Johan Hovold <johan@kernel.org> <jhovold@gmail.com>
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
+John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
 <jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
_

Patches currently in -mm which might be from john@keeping.me.uk are


