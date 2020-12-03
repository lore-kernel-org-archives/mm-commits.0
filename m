Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDC8C1B087
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310232223E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLCV15 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:27:57 -0500
Received: from ozlabs.org ([203.11.71.1]:46835 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgLCV15 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:27:57 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cn8760ZHhz9sT5;
        Fri,  4 Dec 2020 08:27:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607030835;
        bh=utFtH1kW0WWeNiaPFI4/Ds8DfmDRvqw2UMNnK6UIiFk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g9Gw9Ec5PfToXU8OPTwLOwM1OJW7KfVNRq5IWGEX57yA9M/xJa9LWSy0dz+Ha78mP
         G7DSC8+s6YHaSHM+a4QENdhGLovu+Kz6zwq56R8EOkaTcY8ddbif9QXsaLX4Lwgbbn
         unM+kp6cAb2Y7qYzGrRqIxymOeA16ac5zS1XQS+35OtVuxHP7sqIXzlgxGPDdkJdzB
         HuyPYhDuLL4ACpD6E2ANyx0Qg3XdgJNfg5+B7/YxvT5HfI22Mm7z8cAydyI6iRycfi
         +yZTjLrzDpz49nFP3rvRxbkB1UpPraFXM6qCaBAV0JddUL+fpzEYt7pvPtpebCMdYw
         9PgiUELkBWtgw==
Date:   Fri, 4 Dec 2020 08:27:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        guangye.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        qcai@redhat.com
Subject: Re: [failures]
 kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch removed from
 -mm tree
Message-ID: <20201204082713.56c4f6fd@canb.auug.org.au>
In-Reply-To: <20201203205810.Tat-xsb2E%akpm@linux-foundation.org>
References: <20201203205810.Tat-xsb2E%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/q+dG7/q5lZohuS40MsMmiRh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/q+dG7/q5lZohuS40MsMmiRh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 03 Dec 2020 12:58:10 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: kasan: fix object remaining in offline per-cpu quarantine
> has been removed from the -mm tree.  Its filename was
>      kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch
>=20
> This patch was dropped because it had testing failures

I have removed that from linux-next today (and my fixup for it).
--=20
Cheers,
Stephen Rothwell

--Sig_/q+dG7/q5lZohuS40MsMmiRh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/JWDEACgkQAVBC80lX
0Gwoewf/Q9oj/5d7dPapgUEs5akSHd+CP37Q2wix7onKcQm0AIOxqC1jVGy1SqPK
IYBc2CqVUkyPJfs9MYSRNG1OsqiPuFjnx0weTxZMXi4f9y3zlxdxsJ1FcK79n9tY
42n85pOuVv/3UG1+2YgbPknIkEzXxHbAo+YrIR9xPjfCdRkbceX9NUDo32LgSSpn
auX8qmNkE4lyoB4L1B3ldbvhzKV7me4jYk0tq0Un+cW5649F6situbjXkJ6XQZpC
bA5t3Bqx1yeaA/R8Yx/Xya+kWi9yTH8gulbQlIjXws1Gw31cKuP46n/26MN3ADct
FHDJuglDYRFyPAxhKINBqILwe/ThLQ==
=IBiD
-----END PGP SIGNATURE-----

--Sig_/q+dG7/q5lZohuS40MsMmiRh--
