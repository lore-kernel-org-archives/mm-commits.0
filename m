Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F21FC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jan 2022 05:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiADFbE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jan 2022 00:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiADFbE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2022 00:31:04 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3DC061761
        for <mm-commits@vger.kernel.org>; Mon,  3 Jan 2022 21:31:03 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JSh6W3DMyz4xRC;
        Tue,  4 Jan 2022 16:30:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641274261;
        bh=Y4Nf6nsLXEzTXJ58cLPB+VzeJOqbVaVMUOhvbjmhD7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rLGcU+da6OKG956mD38A7fQvTbBqn1Cx046M3PKbr4inQtxS8381MU3JgRGDnYWvY
         sHlPbpcNyImSK8e7xGR1uiF3Z73SJ5pmJ8HNCacNQtKNcIOw8r7j0TjJUJ+t3GK/YG
         OWYDRp9Tc5xNOLLkXXSpJYpKRMu2LAUHfsiVWVxGflEX/Xq6ZJCGgu5E6SQMl1Lajl
         TtLP67gPyaDUTpYGlkHvpX8qOGvJPL3/MDsZhmmpySTAKodKzuHMCI+JvpfwIxRffJ
         3xzxwbwady28FY6Gs+4m9XIRGyqm9D1uc09zT2dhFnfP5mFxidEhjjbxgMTss0BHdR
         4yhcEY1AnZ1eA==
Date:   Tue, 4 Jan 2022 16:30:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        baolin.wang@linux.alibaba.com
Subject: Re: + mm-damon-add-access-checking-for-hugetlb-pages-fix.patch
 added to -mm tree
Message-ID: <20220104163058.0834ffbc@canb.auug.org.au>
In-Reply-To: <20211231021534.IkjJJ%akpm@linux-foundation.org>
References: <20211231021534.IkjJJ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lLkDkMLEgOPjW9r0cM2xMYo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/lLkDkMLEgOPjW9r0cM2xMYo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 30 Dec 2021 18:15:34 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-damon-add-access-checking-for-hugetlb-pages-fix
> has been added to the -mm tree.  Its filename is
>      mm-damon-add-access-checking-for-hugetlb-pages-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/lLkDkMLEgOPjW9r0cM2xMYo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHT25IACgkQAVBC80lX
0Gwe7Af/ccKBV7eY4sU3TOP5m8MyjoGSENDAlt95ir6+vjgdIztYKkmjFjUWqtQW
GDuZRgQpf3fe2asK0MS4d+agFk5bimC4aKnMWMt8sMRtekrbAH2Gu0lv+QivoChv
I7QNRa4393+EIU6mYn464uq6W9SsnG/FHBbvNFZtIzKdsgFskaWnKSMoQ7B2ahPt
H7AHJc+5tCeTO9WW1wlu27mt2TMn1lysSNWZ16UzUASIw1LkZtnNcvm9Tm6k+2DQ
6lBxzmfts+RmzLnLDdJRr59cFlZzu3dRCZ+LSZ+/RsF57Q6p/toVMuwwx2tG3ajD
SV19FvJRHIw6X8X0ZPWHoPBov8tgkg==
=OiZ6
-----END PGP SIGNATURE-----

--Sig_/lLkDkMLEgOPjW9r0cM2xMYo--
