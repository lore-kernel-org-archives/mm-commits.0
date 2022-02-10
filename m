Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D214C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Feb 2022 04:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiBJENk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Feb 2022 23:13:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiBJENj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2022 23:13:39 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9A6BB
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 20:13:39 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JvNf516nYz4xNn;
        Thu, 10 Feb 2022 15:13:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644466413;
        bh=JmTyAI85ivwA7zpahkn8JLtDZz0qmQLHf+tPBbOmPjU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQZIgOaMOjToCs4cQZ/hqtpiKGQmM5H3HP8xWnv7m9BEwVBNwJ9iUodmC//NnGLIg
         XYu+oksUDCkEIVE1AyyuIopNKVgvIDooD2VbxppLxZ3/k68qpuzNFGHDS21X3wONaE
         6OToYZXETmWMj+UvOgQREpxbM+hkR9CNOmODaZvxb/Y3DE5DKcY0EsTt6XTaK0fNRy
         MbMtQbo9oUq8sHDwpbmZ+qFgVxkaB+6wdkwsTH52Z7TEPsyiqRmLec8iQuG28dkb6C
         3+iUk/G5EBfnh6WGL8ey1hOAs+g8BGzIkuZBV4znlFTLB4sxSuUfvo1D/JEUXV9+eM
         guLWkbfp3A05Q==
Date:   Thu, 10 Feb 2022 15:13:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, apopple@nvidia.com, sj@kernel.org
Subject: Re: +
 mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch
 added to -mm tree
Message-ID: <20220210151332.039720ca@canb.auug.org.au>
In-Reply-To: <20220210001829.A530FC340E7@smtp.kernel.org>
References: <20220210001829.A530FC340E7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FDzSrU_ZCKDrqdB++3MVb1O";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/FDzSrU_ZCKDrqdB++3MVb1O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 09 Feb 2022 16:18:29 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The patch titled
>      Subject: mm/gup: make migrate_device_page() fails always if !CONFIG_=
DEVICE_PRIVATE
> has been added to the -mm tree.  Its filename is
>      mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failin=
g-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/FDzSrU_ZCKDrqdB++3MVb1O
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIEkOwACgkQAVBC80lX
0GzlaAgAn8+OgPBbhBy4yT96ebDCok80izrQ+gNzsyb7/K5Jz2/3wNEPnepB2WdN
ABLPheoXE+8aZZMPOGLIKQ11ZLa35VGVCHEEkvWccARWErxfqLPlgNgJnotbS7mH
9mJfV3M9voyK2Gpt5psYkFvn2hjNfeEDjqYofnaiVq+jXVe+DSCsSeAAKTRJ7fCS
lHlkdMAuGG+zPmjcDUEYxD8JBbvibXaHJIGEuGShroUOFvsxl3TB9BByU1T4azT0
hQCb/QFIWPGxLLL1bfzeHpELWmJk8XDV+1KYVAk4IwBhJH3Nr36nsR+6ACgj3jTe
AFS78WIzX7Iyvx7OZL8uYtPzavrpLQ==
=TrrZ
-----END PGP SIGNATURE-----

--Sig_/FDzSrU_ZCKDrqdB++3MVb1O--
