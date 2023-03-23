Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB107C6FD1F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCWBeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCWBdy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B859E
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84DACB81EAB
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A3FC433D2;
        Thu, 23 Mar 2023 01:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535143;
        bh=i+3JUpE7lCi9bqSXJnpHcFPjbL8FJQH+rJKoCYU5lRA=;
        h=Date:To:From:Subject:From;
        b=RWEJVhNhJ3QE885OKNQCRJGpyT+6YTWXsS0wc+mFRRIvTDGG544he4VBHItRc4vIi
         sZAk6eiFaAcyS4hm9a377xwjKkuSvTSdPgKV1fSDDhQGVzKe/nJ0vSR0aj7ockJ82u
         w8SedulW0cToxiBgudug2Cya+kCBRdYSXa4Vgn/c=
Date:   Wed, 22 Mar 2023 18:32:22 -0700
To:     mm-commits@vger.kernel.org, eballetbo@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-enric-balletbo-i-serra.patch removed from -mm tree
Message-Id: <20230323013223.27A3FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for Enric Balletbo i Serra
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-enric-balletbo-i-serra.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enric Balletbo i Serra <eballetbo@kernel.org>
Subject: mailmap: add entry for Enric Balletbo i Serra
Date: Tue, 14 Mar 2023 12:54:55 +0100

Map Enric's old corporate addresses to his kernel.org address.

Link: https://lkml.kernel.org/r/20230314115455.188818-1-eballetbo@kernel.org
Signed-off-by: Enric Balletbo i Serra <eballetbo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-enric-balletbo-i-serra
+++ a/.mailmap
@@ -133,6 +133,8 @@ Dmitry Safonov <0x7f454c46@gmail.com> <d
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Ed L. Cashin <ecashin@coraid.com>
+Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
+Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
 Eugen Hristev <eugen.hristev@collabora.com> <eugen.hristev@microchip.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
_

Patches currently in -mm which might be from eballetbo@kernel.org are


