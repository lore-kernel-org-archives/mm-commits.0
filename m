Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58098C197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjKQRcG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjKQRcF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:32:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE89A5
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:32:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F98C433C8;
        Fri, 17 Nov 2023 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242321;
        bh=heBglfN/LY9BQasqCkoTTtRu8/aWbWIETKjo2KmXLZc=;
        h=Date:To:From:Subject:From;
        b=n0Y0O9yO8bsd4pMZ1gnrs8IsSER00qKhUEYLWd0ZN5h3slenHRsgGtjhfrrU5hc8+
         /sOg+CD0JE+8lm2CdSDkwhDU9BHMZFYS19my4eyK3VsBNYuQ0Is4ctJocDDx6MJMCX
         c4P8YDkr8RffAtihZWviNyzat2xvdaIqnuueVqh0=
Date:   Fri, 17 Nov 2023 09:32:00 -0800
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        quic_bjorande@quicinc.com, o.rempel@pengutronix.de,
        mbrugger@suse.com, kuba@kernel.org, konrad.dybcio@linaro.org,
        heiko@sntech.de, gregkh@linuxfoundation.org,
        conor.dooley@microchip.com, chester62515@gmail.com, clin@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-a-new-address-mapping-for-chester-lin.patch added to mm-hotfixes-unstable branch
Message-Id: <20231117173201.B8F98C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: add a new address mapping for Chester Lin
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-a-new-address-mapping-for-chester-lin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-a-new-address-mapping-for-chester-lin.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chester Lin <clin@suse.com>
Subject: .mailmap: add a new address mapping for Chester Lin
Date: Fri, 17 Nov 2023 10:28:07 +0800

My company email address is going to be disabled so let's create a mapping
that links to my private/community email just in case people might still
try to reach me via the old one.

Link: https://lkml.kernel.org/r/20231117022807.29461-1-clin@suse.com
Signed-off-by: Chester Lin <clin@suse.com>
Cc: Chester Lin <chester62515@gmail.com>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Matthias Brugger <mbrugger@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-a-new-address-mapping-for-chester-lin
+++ a/.mailmap
@@ -117,6 +117,7 @@ Changbin Du <changbin.du@intel.com> <cha
 Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
+Chester Lin <chester62515@gmail.com> <clin@suse.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessm.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessos.org>
 Chris Lew <quic_clew@quicinc.com> <clew@codeaurora.org>
_

Patches currently in -mm which might be from clin@suse.com are

mailmap-add-a-new-address-mapping-for-chester-lin.patch

