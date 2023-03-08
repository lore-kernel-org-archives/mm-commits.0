Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9487AC64EC4
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjCHU0J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCHU0I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:26:08 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9923ED13E6
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=VHfw8aPL5IkGlPn4+tbMq6EuLqbesyxvZE2NCjVq6Og=; b=JP2z2drYd215KFVJh9uvOILcZY
        6wmZFzs3QEig9GxTgAUfD56hcI7WefhOaBGjBVN8/BxzfytPajsAcuayIIDWOpR8eoxHU54VMKZxh
        F9XXf8laG3VJmCXUuL+4Y7VWSiU7EyKA/strF8eKBJy/u8euYMINvLXTzUv+ZBW8dfAmtARkto6xX
        CDNVTTifgObYPHouX0gRhV8SpLb3Nn2gEj4+916flDtj/1Q0B2VYItvHwd9JuVThzjzVDTwihYbHQ
        ONgBu78dQOFdolqS3yOuM8VCaSVL2FUKye9LvC13fY3LQMecAp8j43LtR0v0Dd9tMH8pFAaz/AWtT
        lEQH2TlA==;
Received: from [80.252.65.81] (helo=[127.0.0.1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pa0Lz-00HUG1-1H;
        Wed, 08 Mar 2023 20:25:43 +0000
Date:   Wed, 08 Mar 2023 20:25:36 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, olivia@selenic.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_maintainers-remove-the-obsolete-section-embe?= =?US-ASCII?Q?dded-linux=2Epatch_added_to_mm-nonmm-unstable_branch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230308201811.C007DC433EF@smtp.kernel.org>
References: <20230308201811.C007DC433EF@smtp.kernel.org>
Message-ID: <22909F6B-156F-4447-A738-3E90DCEC1674@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 8 March 2023 20:18:11 GMT, Andrew Morton <akpm@linux-foundation=2Eorg> =
wrote:
>
>The patch titled
>     Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
>has been added to the -mm mm-nonmm-unstable branch=2E  Its filename is
>     maintainers-remove-the-obsolete-section-embedded-linux=2Epatch
>
>This patch will shortly appear at
>     https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/25-new=2Egi=
t/tree/patches/maintainers-remove-the-obsolete-section-embedded-linux=2Epat=
ch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist=2Erst when tes=
ting your code ***
>
>The -mm tree is included into linux-next via the mm-everything
>branch at git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/akpm/mm
>and is updated there every 2-3 working days
>
>------------------------------------------------------
>From: Lukas Bulwahn <lukas=2Ebulwahn@gmail=2Ecom>
>Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
>Date: Wed, 8 Mar 2023 16:06:25 +0100
>
>By now, many developers are working on Linux for embedded systems=2E  The=
re
>is no need to point out single developers=2E  The linux-embedded mailing
>list has only little traffic, and most of it is just spam=2E
>
>Remove this obsolete section=2E
>
>Link: https://lkml=2Ekernel=2Eorg/r/20230308150625=2E28732-1-lukas=2Ebulw=
ahn@gmail=2Ecom
>Signed-off-by: Lukas Bulwahn <lukas=2Ebulwahn@gmail=2Ecom>
>Cc: David Woodhouse <dwmw2@infradead=2Eorg>
>Cc: Olivia Mackall <olivia@selenic=2Ecom>
>Signed-off-by: Andrew Morton <akpm@linux-foundation=2Eorg>


Acked-by: David Woodhouse <dwmw2@infradead=2Eorg>
