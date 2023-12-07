Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE30FC46CA0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441925AbjLGANa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441862AbjLGANV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0934AC
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9BEC433CA;
        Thu,  7 Dec 2023 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908007;
        bh=aYgV8/LwpVZh6LlOQfmXI3hpYIpEFnK28asu22f6uTA=;
        h=Date:To:From:Subject:From;
        b=wqCdDz8gzLgsj+eS8s1nyBt6SzescBSTjmfVQ01ykiuzUuj9R0rHTVuNuEW73JWal
         sZPNXkmMF1cHYQC6aiV/nCR1TZkdXSiX0lstsmXwX/gPfMAISd4U4A8YcTcEevjCrX
         OScjoE9YlZSiRyQsRp3Au4m1mnvXp0wBOoWK+dTg=
Date:   Wed, 06 Dec 2023 16:13:27 -0800
To:     mm-commits@vger.kernel.org, stephen@networkplumber.org,
        quic_bjorande@quicinc.com, o.rempel@pengutronix.de,
        mbrugger@suse.com, kuba@kernel.org, konrad.dybcio@linaro.org,
        heiko@sntech.de, gregkh@linuxfoundation.org,
        conor.dooley@microchip.com, chester62515@gmail.com, clin@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-a-new-address-mapping-for-chester-lin.patch removed from -mm tree
Message-Id: <20231207001327.BD9BEC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: add a new address mapping for Chester Lin
has been removed from the -mm tree.  Its filename was
     mailmap-add-a-new-address-mapping-for-chester-lin.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


