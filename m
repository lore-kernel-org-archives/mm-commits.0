Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E275BC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  6 Dec 2021 07:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhLFHoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Dec 2021 02:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbhLFHoD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Dec 2021 02:44:03 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9432BC061354
        for <mm-commits@vger.kernel.org>; Sun,  5 Dec 2021 23:40:35 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6wML6nbBz4xPw;
        Mon,  6 Dec 2021 18:40:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638776434;
        bh=5xOkxQ5HwoFE6O53dQ8+7tyRwP/8SYCQKxdyEexGAeM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HAU9C+20Cna+CAyXPDPZT7DG/X/q6cVZMUaYowK1iKSMA1h1qBX5fLN3nnSp0Ggye
         09TY0L1+jtFyFvFEw+EEq13iaMGZFMzLcFDpHOnWIMd+6v5otTG+34M/yb8JSM7UWR
         V3B2H/y+Rh5/LTlFP8MX/2T3scwXJ3NcKqder8uIfe2O8cXLlgmpPLbPCxED0qy2Bj
         nGtQss/UL2D/DiStae/5y4w2V1hprf18m1vNgpy6bTqY9ZIQLHYwrE51aD0NV7N8pV
         GxXXqyt2AxDGhIWSof71W2aqtqNwWMENFlrzod0YMc8OKJiNiv7x3R4ZbJ6bEfdN7Z
         xf2+DEqxY/BNQ==
Date:   Mon, 6 Dec 2021 18:40:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     lkp@intel.com, mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject: Re: + proc-remove-pde_data-completely-fix-fix.patch added to -mm
 tree
Message-ID: <20211206184030.2587acc0@canb.auug.org.au>
In-Reply-To: <20211203202810.eIo3hOTZw%akpm@linux-foundation.org>
References: <20211203202810.eIo3hOTZw%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8JT6=c+_3WS2EjuwsH4ZkhR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/8JT6=c+_3WS2EjuwsH4ZkhR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 03 Dec 2021 12:28:10 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: proc-remove-pde_data-completely-fix-fix
> has been added to the -mm tree.  Its filename is
>      proc-remove-pde_data-completely-fix-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/8JT6=c+_3WS2EjuwsH4ZkhR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtvm4ACgkQAVBC80lX
0Gxi6QgAoB4uwxOLa4shBeUR37xgQNx4aCXzw/ambENlquXAdGL19JESVcAWcJG0
eqKMChM5qAk2ka3t7NhEJqH/A8tE37LYzes54wAA5kxYycxvJnnFOBhj3dQgcWa1
sZn/BXmXBM6+vCqy2OeA+ys20eSmlZCHy3BPosjixyeBx76vp5V3FKg8xISrc1ZZ
/8H5zIOgC1A5LJ92g1byxI4+QgRKs7EidFHu4BBd67WaY75/jkx2t566gLGUzdaa
IUubztrqi5hn0kfMZyGs7yO8DG2cmlzT2e2Y2zxNXSFpiPPWcgcuOX3gIdeqja40
/767ZmPwqqZ07uLsqC+a3/OTAkcTbg==
=1UVJ
-----END PGP SIGNATURE-----

--Sig_/8JT6=c+_3WS2EjuwsH4ZkhR--
