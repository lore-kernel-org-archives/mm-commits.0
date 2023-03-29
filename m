Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AB9C761A6
	for <mm-commits@archiver.kernel.org>; Wed, 29 Mar 2023 09:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjC2J4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Mar 2023 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjC2J4s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2023 05:56:48 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951CF187
        for <mm-commits@vger.kernel.org>; Wed, 29 Mar 2023 02:56:45 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EB0535FD1A;
        Wed, 29 Mar 2023 12:56:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680083804;
        bh=NxjlBe1XRgiVVjjsxUEZVl8ogI+zAiCJrVNc6gBQ09I=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=MIloI+OjyGdVBXrFjrNnMYKICQoVchkluojNSCQWRyi9LnwGuUyvgjrIog5pu3xNt
         5YdXsjJhS52XGUniHiGCP8XAecgdEbJUU3CQraS43GBSL0O3WPlwnEIDXCWVTnlMGL
         KXD1GO/QOZArouzoLLh3wysgvwk8mD67wVosl04cqygoG1GWUfve0ZxvvWfK+gaqA1
         7fYxYaVADPDkkpQuZ20PxvqhDOjjHuJ86Ebg2+GW5mXA1b8XcwFgQ7algcQJS7PtDy
         BDDXUsqHN4nrhcBM07N282fL0q4+nvhvAV7Pm5VGweSxW1Amu7NW5Nnjom03hjKCJl
         GAfPaJt/a9vYw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed, 29 Mar 2023 12:56:42 +0300 (MSK)
Date:   Wed, 29 Mar 2023 12:56:42 +0300
From:   Dmitry Rokosov <ddrokosov@sberdevices.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <robh@kernel.org>,
        <lukas.bulwahn@gmail.com>, <joe@perches.com>,
        <dwaipayanray1@gmail.com>, <apw@canonical.com>
Subject: Re: + checkpatch-add-missing-bindings-license-check.patch added to
 mm-nonmm-unstable branch
Message-ID: <20230329095642.dbtybk2xmebi4c7f@CAB-WSD-L081021>
References: <20230321212913.79232C4339B@smtp.kernel.org>
 <287eaf10-d833-e59f-8b82-7084a1d40e21@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <287eaf10-d833-e59f-8b82-7084a1d40e21@linaro.org>
User-Agent: NeoMutt/20220415
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/29 07:09:00 #21026578
X-KSMG-AntiVirus-Status: Clean, skipped
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 29, 2023 at 11:21:06AM +0200, Krzysztof Kozlowski wrote:
> On 21/03/2023 22:29, Andrew Morton wrote:
> > The patch titled
> >      Subject: checkpatch: add missing bindings license check
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      checkpatch-add-missing-bindings-license-check.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-missing-bindings-license-check.patch
> > 
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> > 
> > ------------------------------------------------------
> > From: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> > Subject: checkpatch: add missing bindings license check
> > Date: Mon, 20 Mar 2023 23:33:50 +0300
> > 
> > All headers from 'include/dt-bindings/' must be verified by checkpatch
> > together with Documentation bindings, because all of them are part of the
> > whole DT bindings system.
> > 
> > The requirement is dual licensed and matching pattern:
> >     /GPL-2\.0(?:-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/
> > 
> > The issue was found during patch review:
> > https://lore.kernel.org/all/20230313201259.19998-4-ddrokosov@sberdevices.ru/
> > 
> > Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sberdevices.ru
> > Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> > Acked-by: Joe Perches <joe@perches.com>
> > Cc: Andy Whitcroft <apw@canonical.com>
> > Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > Cc: Rob Herring <robh@kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Hi Andrew,
> 
> Can you drop this patch? Rob raised few concerns and it should be reworked.
> 
> Rob's arguments/comments:
> https://lore.kernel.org/all/20230321215337.GA1656483-robh@kernel.org/
> https://lore.kernel.org/all/CAL_Jsq+-YJsBO+LuPJ=ZQ=eb-monrwzuCppvReH+af7hYZzNaQ@mail.gmail.com/
> https://lore.kernel.org/all/CAL_JsqJa-McFEorLr6ZWNqaEtjG8Oi2rNJ3hGwb2Xk3jvqMZgQ@mail.gmail.com/

Yes, Andrew, please drop this version. I'll send the next one today or
tomorrow.

-- 
Thank you,
Dmitry
