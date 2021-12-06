Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD13C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Dec 2021 07:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbhLFHnc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 02:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhLFHna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 02:43:30 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10353C0613F8
        for <mm-commits@vger.kernel.org>; Sun,  5 Dec 2021 23:40:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6wLm4pg0z4xgq;
        Mon,  6 Dec 2021 18:40:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638776400;
        bh=udLdYbz05OhQ39erBe0YW/MeX2xe5Co8SQCYZ9k6oio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHgBp97BMuNpiGA9lUA1BSXaMgYXGXEyTvwApRHBwnyai+ZJoU+hy89pZLLUnHdAW
         3S+N7INS7+bj4hcsOmfv/WxJMxXPrVJJieymQtMRtCxHVfkfIXxFVlWzx8edt4uWxG
         huN5zRZlShWAPxx0eUHYMaKgspJGHOG+2zBwKX62qOFht+BrzoILqyKYT8Ou/jggYf
         5vPERV0OTIeuaqaJeKdaUa8drZWlaApZCL/pQkCuSbLGYxXGUS22OT3PtCycPePQ9f
         9rNn/5UHpMCgGEgZnC2PYYy8QZefIma7E8mjCNRkhSe60pHc0yLX58eO4U3eXOFWtp
         rDsD4S1EM5RsA==
Date:   Mon, 6 Dec 2021 18:39:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject: Re: + fs-move-dcache-sysctls-to-its-own-file-fix-2.patch added to
 -mm tree
Message-ID: <20211206183959.3a424564@canb.auug.org.au>
In-Reply-To: <20211203201431.NcZXDMsVP%akpm@linux-foundation.org>
References: <20211203201431.NcZXDMsVP%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gum.81=jW50+si+w_2KAJZV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/gum.81=jW50+si+w_2KAJZV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 03 Dec 2021 12:14:31 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: fs/dcache: avoid unused-function warning
> has been added to the -mm tree.  Its filename is
>      fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/gum.81=jW50+si+w_2KAJZV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtvk8ACgkQAVBC80lX
0GxY5Qf/XcNK+KMmuD//5TKYNIB1Nd92AsArNrTNKZFmR2JpfCf9HwAxp0EDpbos
CSLBXCOvcV2nKbznocSYAWA7z2m0DXgVXqDVvN7B2DZwKHeKCMhHJ6SfEbfm5Drq
5OANCR+I89WQR+wfGmmH6mlvKSozGoJnUpZh8HG1pik1taz4pgNsK0JnBOpY5AtD
+eeoVP1XteMq+HZ5X+rpcDt4fSvK8K4Tvmy3Inp9x3Dw95RPHI50qPy02lM7Bkvk
F4SGwmKjMlBoJZKXbNgr/Wx3Rkm7XQ+qlgtNLOcl02+yg69V1Ua/loINVkCksUZy
t/KzYgM/dsiqkM8mFJPTKrfdfRz7zQ==
=dHvK
-----END PGP SIGNATURE-----

--Sig_/gum.81=jW50+si+w_2KAJZV--
