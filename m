Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED917C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD4C7613DB
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243856AbhI2EVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbhI2EVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Sep 2021 00:21:05 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA679C061745
        for <mm-commits@vger.kernel.org>; Tue, 28 Sep 2021 21:19:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HK36Y4dvFz4xLs;
        Wed, 29 Sep 2021 14:19:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632889158;
        bh=bbiaIZ9jckrVjNc2csoOwZjID/b8lQbiogm6i8p11PQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m/84Q3HTsfbOD7AqRzzXpFX85SyjI0v2CUbbZFeuppkIIlzddMLRovgUt9Wu0nUUp
         JsTrJSMUTFGf9kHj7xzz3ZDzQrZ3TXNKLXB0o1DEaAB2Ie24dsYnumbykNYHrmjqRo
         x5yQPix0M1MvB/wzn/TfZT1e3SKh96ENmGIQ/VxFd4/0BvpnFJYc/BCRIQjeNRJ7CO
         CB4v3tgJKSAL2X9vlQUYNRz5057KluZt7NkPTSq9WoWQVHUdrJblZ8A15nzB4WFJ49
         rE8V1fM64jzi6aj67ybMM/sqDT2wHMGkv1LhEYAyiEI4afK0IJt5TcNS+keqpUialT
         /CX1NeAH6v8gQ==
Date:   Wed, 29 Sep 2021 14:19:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        mm-commits@vger.kernel.org, paulus@ozlabs.org
Subject: Re: [to-be-updated]
 mm-create-a-new-system-state-and-fix-core_kernel_text.patch removed from
 -mm tree
Message-ID: <20210929141916.776c72e8@canb.auug.org.au>
In-Reply-To: <20210929033113.cyzBvlSDR%akpm@linux-foundation.org>
References: <20210929033113.cyzBvlSDR%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/v8Sm2fKmkWLnrDvG3RoT7Mo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/v8Sm2fKmkWLnrDvG3RoT7Mo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 28 Sep 2021 20:31:13 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm: create a new system state and fix core_kernel_text()
> has been removed from the -mm tree.  Its filename was
>      mm-create-a-new-system-state-and-fix-core_kernel_text.patch
>=20
> This patch was dropped because an updated version will be merged

I have dropped all 4 patches from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/v8Sm2fKmkWLnrDvG3RoT7Mo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFT6UQACgkQAVBC80lX
0GzfcAf+Ppy1IGGkADRt/jgl0OjtRjbB4FAKuEEjZ/gCs4kA7R3F4Y88alQc4JuN
FGdKnU7gPkAlhjHkQIR0f0y3U5atRSmtYI8XNaxHV4TwQqxmtrkkcb+5a/rNdv8g
GuFXwJ0AiJpAafI38cmQUHNVTWf2lu82y6isF8u6h53setnPg4+Cd/0yuz0FoJDB
VP1J1MdSabAJdiMrFFWvlOMShbWxDzvEWsvq4gHVfwPs2ArjHIm962SVDtezY5BD
siQEbVQeRnENCJHJX+5x46H1snjGJ8g6whHB5d84iVKn7Jxj37wYyy52OCGT3S6+
rg7bkI9B2On1iU+r1c6KhkkzEIgnvA==
=iGo+
-----END PGP SIGNATURE-----

--Sig_/v8Sm2fKmkWLnrDvG3RoT7Mo--
